# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geocodio/version'

Gem::Specification.new do |s|
  s.name          = 'geocodio'
  s.version       = Geocodio::VERSION
  s.authors       = ['David Celis']
  s.email         = ['me@davidcel.is']

  s.summary       = %q{An unofficial Ruby client library for geocod.io}
  s.description   = %q{Geocodio is a geocoding service that aims to fill a void in the community by allowing developers to geocode large amounts of addresses without worrying about daily limits and high costs.}
  s.homepage      = 'https://github.com/davidcelis/geocodio'
  s.license       = 'MIT'

  s.files         = Dir['lib/**/*.rb']
  s.test_files    = Dir['spec/**/*']
  s.require_paths = ['lib']

  s.add_dependency 'json'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'vcr'

  s.add_development_dependency 'coveralls'
end
