# Measure test coverage.
require 'coveralls'
Coveralls.wear!

require 'geocodio'
require 'webmock/rspec'
require 'vcr'

ENV['GEOCODIO_API_KEY'] ||= 'secret_api_key'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('secret_api_key') { ENV['GEOCODIO_API_KEY'] }
end

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end

RSpec::Expectations.configuration.on_potential_false_positives = :nothing
