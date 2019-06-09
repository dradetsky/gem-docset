lib = File.join __dir__, 'lib'
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gem-docset/version'

Gem::Specification.new do |spec|
  spec.name          = "gem-docset"
  spec.version       = GemDocset::VERSION
  spec.authors       = ['dmr']
  spec.email         = ['dradetsky@gmail.com']

  spec.summary       = %q{build docset from rdoc}

  spec.license       = 'WTFPL'

  spec.add_dependency "rdoc", "~> 6.1"
end
