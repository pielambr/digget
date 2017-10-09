$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'digget/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "digget"
  s.version     = Digget::VERSION
  s.authors     = ["Pieterjan"]
  s.email       = ["me@pielambr.be"]
  s.homepage    = "https://www.pielambr.be"
  s.summary     = "Summary of Digget."
  s.description = "Description of Digget."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.6"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "byebug"
  s.add_development_dependency "yard"
  s.add_development_dependency "codecov"
end
