# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'file_tree_profiler/version'

Gem::Specification.new do |gem|
  gem.name          = "file_tree_profiler"
  gem.version       = FileTreeProfiler::VERSION
  gem.authors       = ["Jens Bissinger"]
  gem.email         = ["mail@jens-bissinger.de"]
  gem.description   = %q{Generates a profile of a given directory.}
  gem.summary       = %q{Analysed directory structure and file contents.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'sequel'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rspec-nc'
end
