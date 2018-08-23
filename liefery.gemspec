# -*- encoding: utf-8 -*-

$:.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'liefery/version'

Gem::Specification.new do |spec|
  spec.name        = 'liefery'
  spec.version     = Liefery::VERSION
  spec.date        = '2014-05-12'
  spec.summary     = %q(A Ruby interface to Pactas.Itero API)
  spec.description = %q(A Ruby interface to Pactas.Itero API)
  spec.authors     = ["Simon Fröhler"]
  spec.email       = 'simon@webionate.de'
  # spec.homepage    = 'http://rubygems.org/gems/hola'
  spec.license     = 'MIT'

  spec.files = Dir["lib/**/*.rb"] + Dir["bin/*"]
  spec.files += Dir["[A-Z]*"] + Dir["spec/**/*"]
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.executables   = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 0.9.0'
  spec.add_dependency 'faraday_middleware', '~> 0.9.1'
  spec.add_dependency 'rash', '~> 0.4.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.3.2'
  spec.add_development_dependency "rspec", "~> 3.8.0"
  spec.add_development_dependency 'simplecov', '~> 0.9.0'
  spec.add_development_dependency 'webmock', '~> 1.18.0'
end
