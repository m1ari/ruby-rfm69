# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rfm69/version'

Gem::Specification.new do |spec|
  spec.name          = "rfm69"
  spec.version       = RFM69::VERSION
  spec.authors       = ["Mike Axford"]
  spec.email         = ["mike@m1ari.co.uk"]

  spec.summary       = %q{Library to talk to the HopeRF RFM69 radio module.}
  #spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/m1ari/ruby-rfm69"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "spi"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
