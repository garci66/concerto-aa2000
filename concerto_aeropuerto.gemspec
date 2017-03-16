$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "concerto_aeropuerto/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "concerto_aeropuerto"
  s.version     = ConcertoAeropuerto::VERSION
  s.authors     = ["Diego Garcia del Rio"]
  s.email       = ["garci66@gmail.com"]
  s.homepage    = "https://github.com/garci66/concerto-aa2000"
  s.summary     = "Aeropuerto plugin for Concerto 2."
  s.description = "Show the current flight status (arr/dep) for AA2000 Argentinian Airports"
  s.license     = 'Apache 2.0'

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails"
  s.add_dependency "nokogiri"
  s.add_dependency "concerto_iframe"

end
