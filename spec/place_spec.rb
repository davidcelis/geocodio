require 'spec_helper'

describe Geocodio::Place do
  let(:geocodio) { Geocodio::Client.new }

  subject(:place) do
    VCR.use_cassette('geocode_with_fields') do
      geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[cd stateleg school census timezone]).best.census.latest.place
    end
  end

  it 'has a name' do
    expect(place.name).to eq('Pasadena')
  end

  it 'has a fips' do
    expect(place.fips).to eq('0656000')
  end
end
