# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'onix3/version'

Gem::Specification.new do |spec|
  spec.name          = "onix3"
  spec.version       = Onix3::VERSION
  spec.authors       = ["Eric Daspet"]
  spec.email         = ["eric.daspet@survol.fr"]
  spec.description   = %q{ONIX v3 parser}
  spec.summary       = %q{ONIX v3 parser}
  spec.homepage      = "https://github.com/edas/onix3"
  spec.license       = "LGPL3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"
  spec.add_dependency "optitron"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
end
