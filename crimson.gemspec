# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crimson/version'

Gem::Specification.new do |spec|
  spec.name          = "crimson"
  spec.version       = Crimson::VERSION
  spec.authors       = ["Rizwan Qureshi"]
  spec.email         = ["rizwan@ualberta.ca"]

  spec.summary       = %q{Develop server-sided web-apps using Ruby!}
  spec.description   = %q{This library helps you write server-sided web apps using Ruby.}
  spec.homepage      = "https://github.com/rizwan146/crimson"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
