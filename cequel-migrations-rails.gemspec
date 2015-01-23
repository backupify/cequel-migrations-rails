# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cequel-migrations-rails/version'

Gem::Specification.new do |gem|
  gem.name          = "cequel-migrations-rails"
  gem.version       = CequelCQL2::Migrations::Rails::VERSION
  gem.authors       = ["Andrew De Ponte"]
  gem.email         = ["cyphactor@gmail.com"]
  gem.description   = %q{Cequel migration support for Rails.}
  gem.summary       = %q{A Rails plugin that provides migration support for Cequel.}
  gem.homepage      = "http://github.com/reachlocal/cequel-migrations-rails"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('shearwater', '>= 0.1.3')
  gem.add_dependency('rails')
  gem.add_dependency('cassandra-cql')
  gem.add_development_dependency('rspec')
end
