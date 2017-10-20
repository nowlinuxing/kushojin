# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kushojin/version'

Gem::Specification.new do |spec|
  spec.name          = "kushojin"
  spec.version       = Kushojin::VERSION
  spec.authors       = ["Loose coupling"]
  spec.email         = ["loosecplg@gmail.com"]

  spec.summary       = %q{Detect changes of model attributes and send to outside.}
  spec.description   = %q{Detect changes of model attributes and send to outside.}
  spec.homepage      = "https://github.com/nowlinuxing/kushojin/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop"
end
