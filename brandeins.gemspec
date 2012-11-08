# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "brandeins/version"

Gem::Specification.new do |s|
  s.name        = "brandeins"
  s.version     = BrandEins::VERSION
  s.authors     = ["Gregory Igelmund"]
  s.email       = ["gregory.igelmund@gmail.com"]
  s.homepage    = "http://www.grekko.de"
  s.summary     = %q{BrandEins gem allows you to download past volumes of the Brand Eins magazine}
  s.description = %q{BrandEins gem offers two commands: 'brandeins --year=YYYY' and 'brandeins --year=YYYY --volume=N'}

  s.add_dependency "rake"
  s.add_dependency "thor"
  s.add_dependency "nokogiri"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.post_install_message =<<-EOT
BrandEins gem depends currently runs on unix systems only and depends on pdftk to merge downloaded pdfs.
Run `brandeins setup` to check if all requirements are met and for informations on how to meet them.
EOT
end
