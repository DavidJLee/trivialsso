# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "trivialsso/version"

Gem::Specification.new do |s|
  s.name        = "trivialsso"
  s.version     = Trivialsso::VERSION
  s.authors     = ["David J. Lee"]
  s.email       = ["david@lee.dj"]
  s.homepage    = ""
  s.summary     = "A simple library to help with Single Sign On cookies"
  s.description = "Used to encode and decode cookies used in a single sign on implementation within the same domain"

  s.rubyforge_project = "trivialsso"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
