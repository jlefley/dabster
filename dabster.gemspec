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
  spec.homepage      = ''
  spec.license       = 'MIT'

  #spec.files         = `git ls-files -z`.split('\x0')
  spec.files         = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  #spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.executables   = ['dabster']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec'

  spec.add_dependency 'rails', '~> 4.0.3'
  spec.add_dependency 'sqlite3'
  spec.add_dependency 'sequel-rails'
  spec.add_dependency 'will_paginate'
  spec.add_dependency 'sequel'
  spec.add_dependency 'json'
  spec.add_dependency 'htmlentities'
  spec.add_dependency 'similar_text'
  spec.add_dependency 'fuzzy_match'
  spec.add_dependency 'ruby-progressbar'
  spec.add_dependency 'thor'
end
