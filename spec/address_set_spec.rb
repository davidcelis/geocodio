require 'spec_helper'

describe Geocodio::AddressSet do
  let(:geocodio) { Geocodio::Client.new }
  let(:addresses) do
    [
      '1 Infinite Loop Cupertino CA 95014',
      '54 West Colorado Boulevard Pasadena CA 91105',
      '826 Howard Street San Francisco CA 94103'
    ]
  end

  subject(:address_set) do
    VCR.use_cassette('batch_geocode') do
      geocodio.geocode(*addresses).last
    end
  end

  it 'has a size' do
    expect(address_set.size).to eq(2)
  end

  it 'has a best' do
    expect(address_set.best).to be_a(Geocodio::Address)
    expect(address_set.best.accuracy).to eq(1)
  end

  it 'references the original query' do
    expect(address_set.query).to eq('826 Howard Street San Francisco CA 94103')
  end
end
