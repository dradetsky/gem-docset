gem-docset
==========

make a docset from a gem

usage
-----

currently, it's something like

```ruby
in_path = '/home/dmr/.gem/ruby/2.6.0/doc/sequel-5.21.0'
bldr = GemDocset::Builder.new in_path
# generates /home/dmr/.docsets/sequel.docset
bldr.build
```

eventually, there should be a cli interface.

todo
----

0. build rdoc html if it doesn't exist

1. add more stuff (guides, constants, attributes, modules, variables, etc)

2. ensure anchor tags work for edge cases. for example `Hash#|` ->
   `Hash.html#method-i-|`, but the actual tag is `method-i-7C`

background
----------

In Dash.app, you can (apparently) just add installed gems to the
docsets in your library. I needed a way to do this for my docbrowse
project. As it turns out, this functionality isn't currently built
into, e.g., zeal. And of course it'd be nice if there was a FOSS way
to build them, wouldn't it?

I started working on nodejs docs for docbrowse on the theory I was
about to take the job where I'd be doing a lot of javascript. As it
turned out, I took the job where I'd be doing a lot of Ruby. As a
result, this one became way more urgent than the redo of the node
docs.

acknowledgements
-----------------

I found [yasslab/docset](https://github.com/yasslab/docset) handy.
I've ended up having to refactor it to the point where I'll probably
have to just fork it (especially since they don't appear to have
touched it lately), but hey.
