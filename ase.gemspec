# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ase/version'

Gem::Specification.new do |spec|
  spec.name          = "ase"
  spec.version       = ASE::VERSION
  spec.authors       = ["Ryan LeFevre"]
  spec.email         = ["meltingice8917@gmail.com"]
  spec.description   = %q{Reader/writer for Adobe Swatch Exchange files}
  spec.summary       = %q{Reader/writer for Adobe Swatch Exchange files. Can be used across the entire Adobe Creative Suite.}
  spec.homepage      = "http://cosmos.layervault.com/aserb.html"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rspec"
end
