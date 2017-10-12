# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'firebase/messaging/version'

Gem::Specification.new do |spec|
  spec.name          = 'firebase-messaging'
  spec.version       = Firebase::Messaging::VERSION
  spec.authors       = ['ntkm']
  spec.email         = ['aui.tkm@gmail.com']

  spec.summary       = 'Firebase Messaging Client'
  spec.description   = 'Remote Push Notification to iOS/Android via Firebase.'
  spec.homepage      = 'https://github.com/ntkm'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 0.9', '>= 0.9.2'
  spec.add_dependency 'faraday_middleware', '~> 0.9', '>= 0.9.2'
  spec.add_dependency 'activesupport', '>= 4.0.0'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
end
