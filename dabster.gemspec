# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dabster/version'

Gem::Specification.new do |spec|
  spec.name          = 'dabster'
  spec.version       = Dabster::VERSION
  spec.authors       = ['Jason Lefley']
  spec.email         = ['jlefley@gmail.com']
  spec.summary       = %q{Meta manager for digital music libraries}
  #spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = 'https://github.com/jlefley/dabster'
  spec.license       = 'MIT'

  spec.files         = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  spec.executables   = ['dabster']
  spec.test_files    = Dir['spec/**/*']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec',   '~> 2.14.1'
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rails',   '~> 4.0.4'
  spec.add_development_dependency 'rake'

  spec.add_dependency 'sequel-rails',     '~> 0.9.2'
  spec.add_dependency 'sqlite3',          '~> 1.3.9'
  spec.add_dependency 'will_paginate',    '~> 3.0.5'
  spec.add_dependency 'sequel',           '~> 4.9.0'
  spec.add_dependency 'json',             '~> 1.8.1'
  spec.add_dependency 'htmlentities',     '~> 4.3.1'
  spec.add_dependency 'similar_text',     '~> 0.0.4'
  spec.add_dependency 'fuzzy_match',      '~> 2.0.4'
  spec.add_dependency 'ruby-progressbar', '~> 1.4.2'
  spec.add_dependency 'thor',             '~> 0.19.1'
end
