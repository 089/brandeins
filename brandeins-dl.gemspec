# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "brandeins-dl/version"

Gem::Specification.new do |s|
  s.name        = "brandeins-dl"
  s.version     = BrandEins::VERSION
  s.authors     = ["Gregory Igelmund"]
  s.email       = ["gregory.igelmund@gmail.com"]
  s.homepage    = "http://www.grekko.de"
  s.summary     = %q{BrandEins Downloader allows you to download past volumes of the Brand Eins magazine}
  s.description = %q{BrandEins Downloader offers two commands: 'thor brandeins download YEAR' and 'thor brandeins download YEAR --volume=NUMBER'}

  #s.rubyforge_project = "brandeins-dl"
  s.add_dependency "nokogiri"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
