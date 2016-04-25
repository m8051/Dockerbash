# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dockerbash/version'

Gem::Specification.new do |spec|
  spec.name          = "dockerbash"
  spec.version       = Dockerbash::VERSION
  spec.authors       = ["Jordi"]
  spec.email         = ["crawler8086@gmail.com"]

  spec.summary       = %q{A script to make it easier to execute a bash into running Docker containers}
  spec.description   = %q{Sometimes when you are running docker containers, you need to inspect the status of services, files, configurations, this gem provides the ability to log into running containers using a GNU Bourne-Shell and debug the container from another shell}
  spec.homepage      = "https://github.com/m8051/dockerbash"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ["dockerbash"]
  spec.require_paths = ["lib"]
  spec.rubygems_version = "1.8.23"

  spec.add_runtime_dependency 'highline', '~> 1.7'
  spec.add_runtime_dependency 'rest-client', '~> 1.8'
  spec.add_runtime_dependency 'colorize', '~> 0.7'
  spec.add_runtime_dependency 'json', '~> 1.8'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

end
