# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'meangirls/version'

Gem::Specification.new do |spec|
  spec.name          = "meangirls"
  spec.version       = Meangirls::VERSION
  spec.authors       = ["Kyle Kingsbury"]
  spec.email         = ["aphyr@aphyr.com"]
  spec.description   = %q{Serializable data types for eventually consistent systems.}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/aphyr/meangirls"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "bacon"
  spec.add_development_dependency "mocha-on-bacon"
  spec.add_development_dependency "yajl-ruby"
end
