# encoding: utf-8

$LOAD_PATH.unshift(File.expand_path('../lib/', __FILE__))
require 'nanoc/checking/version'

Gem::Specification.new do |s|
  s.name        = 'nanoc-checking'
  s.version     = Nanoc::Checking::VERSION
  s.homepage    = 'http://nanoc.ws/'
  s.summary     = 'Check support for nanoc'
  s.description = 'Provides checking support for nanoc'

  s.author  = 'Denis Defreyne'
  s.email   = 'denis.defreyne@stoneship.org'
  s.license = 'MIT'

  s.required_ruby_version = '>= 1.9.3'

  s.files              = Dir['[A-Z]*'] +
                         Dir['{lib,test}/**/*'] +
                         [ 'nanoc-check.gemspec' ]
  s.require_paths      = [ 'lib' ]

  s.rdoc_options     = [ '--main', 'README.md' ]
  s.extra_rdoc_files = [ 'LICENSE', 'README.md', 'NEWS.md' ]

  s.add_runtime_dependency('nanoc-core')
  s.add_runtime_dependency('nanoc-cli')
  s.add_runtime_dependency('w3c_validators')
  s.add_runtime_dependency('nokogiri')
  s.add_runtime_dependency('colored')
  s.add_development_dependency('bundler')
end
