# -*- encoding: utf-8 -*-
require File.expand_path('../lib/selection_options_for/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mark Windholtz"]
  gem.email         = ["mark@agiledna.com"]
  gem.summary       = %q{Display labels and symbolic references }
  gem.description   = %q{
   This code allows you to keep the display labels in the model 
   when the DB holds only a 1 character flag.
   and when the code requires symbolic references to the value to use in algorithms
   
   This gem is superceded by the gem state_objects
   Please migrate to: https://rubygems.org/gems/state_objects
       
   Limitations: Don't use this if you will run reports directly against the DB 
   In that case, the reports will not have access to the display labels    
  }
  gem.homepage      = "https://github.com/mwindholtz/selection_options_for"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "selection_options_for"
  gem.require_paths = ["lib"]
  gem.version       = SelectionOptionsFor::VERSION
  
  gem.add_development_dependency "supermodel"
  gem.add_runtime_dependency     "activerecord"
end

