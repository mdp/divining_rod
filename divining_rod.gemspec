# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "divining_rod/version"

Gem::Specification.new do |s|
  s.name        = "divining_rod"
  s.version     = DiviningRod::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mark Percival"]
  s.email       = ["mark@markpercival.us"]
  s.homepage    = "http://github.com/mdp/divining_rod"
  s.summary     = %q{An opinionated ruby encryption library}
  s.description = %q{Supports OpenSSL compatible AES, HMAC, and RSA encryption}

  s.rubyforge_project = "divining_rod"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
