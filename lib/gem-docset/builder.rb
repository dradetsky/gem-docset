require 'fileutils'

require 'rdoc'

require 'docset'

module GemDocset
  class Builder
    DEFAULT_OUT_BASE = File.expand_path '~/.docsets'

    attr_reader :store
    attr_reader :out

    def initialize in_path
      @in_path = in_path
      @store = RDoc::RI::Store.new ri_path, :gem
      @docset = Docset::Base.new out_dir
    end

    def inferred_gem_name
      base = File.basename @in_path
      a, b, c = base.rpartition '-'
      (a.empty? and b.empty?) ? c : a
    end

    def out_dir
      docset_name = inferred_gem_name + '.docset'
      File.join DEFAULT_OUT_BASE, docset_name
    end

    def build
      ensure_rdoc_html

      @store.load_all
      setup_output

      add_classes
      add_class_instance_methods

      link_rdoc
    end


    def ensure_rdoc_html
      if not File.exists? rdoc_path
        raise GemDocset::Error.new 'rdoc'
      end
    end

    def setup_output
      create_dirs
      # @docset.db.reset
      @docset.db.init
      # uniq idx to allow repeatable insert
      @docset.db.finish
    end

    def finalize
      @docset.db.finish
    end

    def class_names_to_filter
      [
        "Array",
        "FalseClass",
        "Hash",
        "NilClass",
        "Numeric",
        "Object",
        "Range",
        "String",
        "Symbol",
        "TrueClass"
      ]
    end

    def filtered_class_names
      @store.classes_hash.keys.reject do |klass_name|
        class_names_to_filter.include? klass_name
      end
    end

    def add_classes
      filtered_class_names.each do |klass_name|
        row = GemDocset.class_row klass_name
        @docset.add_index *row
      end
    end

    def add_class_instance_methods
      @store.cache[:instance_methods].each_pair do |klass_name, methods_list|
        methods_list.each do |method_name|
          row = GemDocset.instance_method_row klass_name, method_name
          @docset.add_index *row
        end
      end
    end

    def add_guides
      # @store.cache[:pages]
      raise NotImplementedError
    end
    
    def rdoc_path
      # File.join File.dirname(@in_path), 'rdoc'
      File.join @in_path, 'rdoc'
    end

    def ri_path
      File.join @in_path, 'ri'
    end

    def create_dirs
      target_dir = @docset.resources_path
      FileUtils.mkdir_p target_dir
    end

    # for making local-only docs
    def link_rdoc
      begin
        File.symlink rdoc_path, @docset.documents_path
      rescue Errno::EEXIST
      end
    end

    # for making redistributable docs; cp -r rdoc_path @docset.documents_path
    def copy_rdoc
      raise NotImplementedError
    end
  end


  # XXX: make into classes. it's an oop language for chrissake, don't
  # fight it!
  def self.instance_method_row klass_name, method_name
    path = instance_method_path klass_name, method_name
    name = [klass_name, method_name].join '#'
    row = [name, 'Method', path]
  end

  def self.instance_method_path klass_name, method_name
    base_path = class_path klass_name
    method_anchor = 'method-i-' + method_name
    path = [base_path, method_anchor].join '#'
  end

  def self.class_row klass_name
    path = class_path klass_name
    row = [klass_name, 'Class', path]
  end

  def self.class_path klass_name
    comps = klass_name.split '::'
    File.join(*comps) + '.html'
  end
end
