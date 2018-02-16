require 'spec_helper'

describe Geocodio::Client do
  let(:geocodio)    { Geocodio::Client.new }
  let(:address)     { '54 West Colorado Boulevard Pasadena CA 91105' }
  let(:coordinates) { '34.145760590909,-118.15204363636' }

  it 'requires an API key' do
    VCR.use_cassette('invalid_key') do
      expect { geocodio.geocode([address]) }.to raise_error(Geocodio::Client::Error)
    end
  end

  it 'parses an address into components' do
    VCR.use_cassette('parse') do
      result = geocodio.parse(address)

      expect(result).to be_a(Geocodio::Address)
    end
  end

  it 'sets the read_timeout on the underlying Net::HTTP request if passed an option' do
    expect_any_instance_of(Net::HTTP).to receive(:read_timeout=).with(60 * 5)
    VCR.use_cassette('geocode') { geocodio.geocode([address], timeout: 60 * 5) }
  end

  describe '#geocode' do
    it 'geocodes a single address' do
      VCR.use_cassette('geocode') do
        addresses = geocodio.geocode([address])

        expect(addresses.size).to eq(2)
        expect(addresses).to be_a(Geocodio::AddressSet)
      end
    end

    it 'geocodes a single address with an options hash' do
      VCR.use_cassette('geocode_with_fields') do
        addresses = geocodio.geocode([address], fields: %w[cd stateleg school timezone])

        expect(addresses.size).to eq(2)
        expect(addresses).to be_a(Geocodio::AddressSet)
      end
    end

    it 'raises a client error when geocoding a bad address' do
      VCR.use_cassette('geocode_bad_address') do
        expect { geocodio.geocode([' , , ']) }.to raise_error(Geocodio::Client::Error)
      end
    end

    it 'geocodes multiple addresses' do
      VCR.use_cassette('batch_geocode') do
        addresses = [
          '1 Infinite Loop Cupertino CA 95014',
          '54 West Colorado Boulevard Pasadena CA 91105',
          '826 Howard Street San Francisco CA 94103'
        ]

        addresses = geocodio.geocode(addresses)

        expect(addresses.size).to eq(3)
        addresses.each { |address| expect(address).to be_a(Geocodio::AddressSet) }
      end
    end

    it 'will return empty AddressSets for bad addresses in a batch geocode' do
      VCR.use_cassette('batch_geocode_with_bad_address') do
        addresses = [
          '1 Infinite Loop Cupertino CA 95014',
          ' , , '
        ]

        addresses = geocodio.geocode(addresses)

        expect(addresses.last).to be_empty
      end
    end

    it 'geocodes multiple addresses with an options hash' do
      VCR.use_cassette('batch_geocode_with_fields') do
        addresses = [
          '1 Infinite Loop Cupertino CA 95014',
          '54 West Colorado Boulevard Pasadena CA 91105',
          '826 Howard Street San Francisco CA 94103'
        ]

        addresses = geocodio.geocode(addresses, fields: %w[cd stateleg school timezone])

        expect(addresses.size).to eq(3)
        addresses.each { |address| expect(address).to be_a(Geocodio::AddressSet) }
      end
    end
  end

  describe '#reverse_geocode' do
    context 'with a single address' do
      it 'uses strings' do
        VCR.use_cassette('reverse') do
          addresses = geocodio.reverse_geocode([coordinates])

          expect(addresses.size).to eq(5)
          expect(addresses).to be_a(Geocodio::AddressSet)
        end
      end

      it 'handles a response without legislator house info' do
        VCR.use_cassette('reverse_with_fields_no_house_info') do
          expect{geocodio.reverse_geocode(["41.25,-96.00"], fields: %w[cd stateleg school timezone])}.to_not raise_error(NoMethodError)
        end
      end

      it 'uses hashes' do
        VCR.use_cassette('reverse') do
          lat, lng = coordinates.split(',')
          addresses = geocodio.reverse_geocode([{ latitude: lat, longitude: lng }])

          expect(addresses.size).to eq(5)
          expect(addresses).to be_a(Geocodio::AddressSet)
        end
      end

      it 'accepts an options hash' do
        VCR.use_cassette('reverse_with_fields') do
          lat, lng = coordinates.split(',')
          addresses = geocodio.reverse_geocode([{ latitude: lat, longitude: lng} ], fields: %w[cd stateleg school timezone])

          expect(addresses.size).to eq(5)
          expect(addresses).to be_a(Geocodio::AddressSet)
        end
      end
    end

    context 'reverse geocoding multiple addresses' do
      it 'uses strings' do
        VCR.use_cassette('batch_reverse') do
          coordinate_pairs = [
            '37.331669,-122.03074',
            '34.145760590909,-118.15204363636',
            '37.7815,-122.404933'
          ]

          addresses = geocodio.reverse_geocode(coordinate_pairs)

          expect(addresses.size).to eq(3)
          addresses.each { |address| expect(address).to be_a(Geocodio::AddressSet) }
        end
      end

      it 'uses hashes' do
        VCR.use_cassette('batch_reverse') do
          coordinate_pairs = [
            { latitude: 37.331669,       longitude: -122.03074 },
            { latitude: 34.145760590909, longitude: -118.15204363636 },
            { latitude: 37.7815,         longitude: -122.404933 }
          ]

          addresses = geocodio.reverse_geocode(coordinate_pairs)

          expect(addresses.size).to eq(3)
          addresses.each { |address| expect(address).to be_a(Geocodio::AddressSet) }
        end
      end

      it 'uses an arbitrary combination of strings and hashes' do
        VCR.use_cassette('batch_reverse') do
          coordinate_pairs = [
            { latitude: 37.331669, longitude: -122.03074 },
            '34.145760590909,-118.15204363636',
            { latitude: 37.7815,   longitude: -122.404933 }
          ]

          addresses = geocodio.reverse_geocode(coordinate_pairs)

          expect(addresses.size).to eq(3)
          addresses.each { |address| expect(address).to be_a(Geocodio::AddressSet) }
        end
      end

      it 'accepts an options hash' do
        VCR.use_cassette('batch_reverse_with_fields') do
          coordinate_pairs = [
            { latitude: 37.331669, longitude: -122.03074 },
            '34.145760590909,-118.15204363636',
            { latitude: 37.7815,   longitude: -122.404933 }
          ]

          addresses = geocodio.reverse_geocode(coordinate_pairs, fields: %w[cd stateleg school timezone])

          expect(addresses.size).to eq(3)
          addresses.each { |address| expect(address).to be_a(Geocodio::AddressSet) }
        end
      end
    end
  end
end
