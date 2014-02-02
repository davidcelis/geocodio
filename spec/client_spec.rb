require 'spec_helper'

describe Geocodio::Client do
  let(:geocodio) { Geocodio::Client.new }
  let(:address) { '54 West Colorado Boulevard Pasadena CA 91105' }

  it 'requires an API key' do
    VCR.use_cassette('invalid_key') do
      expect { geocodio.geocode(address) }.to raise_error(Geocodio::Client::Error)
    end
  end

  it 'parses an address into components' do
    VCR.use_cassette('parse') do
      result = geocodio.parse(address)

      expect(result).to be_a(Geocodio::Address)
    end
  end

  it 'geocodes a single address' do
    VCR.use_cassette('geocode') do
      addresses = geocodio.geocode(address)

      expect(addresses.size).to eq(2)
      expect(addresses).to be_a(Geocodio::AddressSet)
    end
  end

  it 'geocodes multiple addresses' do
    VCR.use_cassette('batch_geocode') do
      addresses = [
        '1 Infinite Loop Cupertino CA 95014',
        '54 West Colorado Boulevard Pasadena CA 91105',
        '826 Howard Street San Francisco CA 94103'
      ]

      addresses = geocodio.geocode(*addresses)

      expect(addresses.size).to eq(3)
      addresses.each { |address| expect(address).to be_a(Geocodio::AddressSet) }
    end
  end
end
