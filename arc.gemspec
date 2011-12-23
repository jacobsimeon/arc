# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "arc/version"

Gem::Specification.new do |s|
  s.name        = "arc"
  s.version     = Arc::VERSION
  s.authors     = ["Jacob Morris"]
  s.email       = ["jacob.s.morris@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A lightweight driver for multiple sql backends}
  s.description = %q{Compatible with mysql, sqlite, and postgres}

  s.rubyforge_project = "arc"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'agent-q'
  s.add_dependency 'arel'
  
  s.add_development_dependency 'pg'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'mysql2'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
 
end
