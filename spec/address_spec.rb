require 'spec_helper'

describe Geocodio::Address do
  let(:geocodio) { Geocodio::Client.new }
  
  context 'when parsed' do
    subject(:address) do
      VCR.use_cassette('parse') do
        geocodio.parse('54 West Colorado Boulevard Pasadena CA 91105')
      end
    end

    it 'has a number' do
      expect(address.number).to eq('54')
    end

    it 'has a predirectional' do
      expect(address.predirectional).to eq('W')
    end

    it 'has a street' do
      expect(address.street).to eq('Colorado')
    end

    it 'has a formatted_street' do
      expect(address.formatted_street).to eq('W Colorado Blvd')
    end

    it 'has a suffix' do
      expect(address.suffix).to eq('Blvd')
    end

    it 'has a city' do
      expect(address.city).to eq('Pasadena')
    end

    it 'has a state' do
      expect(address.state).to eq('CA')
    end

    it 'has a zip' do
      expect(address.zip).to eq('91105')
    end

    it 'does not have a latitude' do
      expect(address.latitude).to be_nil
      expect(address.lat).to      be_nil
    end

    it 'does not have a longitude' do
      expect(address.longitude).to be_nil
      expect(address.lng).to       be_nil
    end

    it 'does not have an accuracy' do
      expect(address.accuracy).to be_nil
    end

    it 'does not have an accuracy_type' do
      expect(address.accuracy_type).to be_nil
    end
  end

  context 'when geocoded' do
    context 'has predirectional' do
      subject(:address) do
        VCR.use_cassette('geocode') do
          geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105']).best
        end
      end

      it 'has a number' do
        expect(address.number).to eq('54')
      end

      it 'has a predirectional' do
        expect(address.predirectional).to eq('W')
      end

      it 'has a street' do
        expect(address.street).to eq('Colorado')
      end

      it 'has a formatted_street' do
        expect(address.formatted_street).to eq('W Colorado Blvd')
      end

      it 'has a suffix' do
        expect(address.suffix).to eq('Blvd')
      end

      it 'has a city' do
        expect(address.city).to eq('Pasadena')
      end

      it 'has a county' do
        expect(address.county).to eq('Los Angeles County')
      end

      it 'has a state' do
        expect(address.state).to eq('CA')
      end

      it 'has a zip' do
        expect(address.zip).to eq('91105')
      end

      it 'has a latitude' do
        expect(address.latitude).to eq(34.145375)
        expect(address.lat).to      eq(34.145375)
      end

      it 'has a longitude' do
        expect(address.longitude).to eq(-118.151622)
        expect(address.lng).to       eq(-118.151622)
      end

      it 'has an accuracy' do
        expect(address.accuracy).to eq(1)
      end

      it 'has an accuracy_type' do
        expect(address.accuracy_type).to eq("rooftop")
      end
      
      it 'has a source' do
        expect(address.source).to eq("Los Angeles")
      end
    end

    context 'has postdirectional' do
      subject(:address) do
        VCR.use_cassette('geocode_with_postdirectional') do
          geocodio.geocode(['1600 Pennsylvania Ave NW Washington DC 20500']).best
        end
      end

      it 'has a number' do
        expect(address.number).to eq('1600')
      end

      it 'has a street' do
        expect(address.street).to eq('Pennsylvania')
      end

      it 'has a formatted_street' do
        expect(address.formatted_street).to eq('Pennsylvania Ave NW')
      end

      it 'has a postdirectional' do
        expect(address.postdirectional).to eq('NW')
      end

      it 'has a suffix' do
        expect(address.suffix).to eq('Ave')
      end

      it 'has a city' do
        expect(address.city).to eq('Washington')
      end

      it 'has a county' do
        expect(address.county).to eq('District of Columbia')
      end

      it 'has a state' do
        expect(address.state).to eq('DC')
      end

      it 'has a zip' do
        expect(address.zip).to eq('20500')
      end

      it 'has a latitude' do
        expect(address.latitude).to eq(38.897675)
        expect(address.lat).to      eq(38.897675)
      end

      it 'has a longitude' do
        expect(address.longitude).to eq(-77.036547)
        expect(address.lng).to       eq(-77.036547)
      end

      it 'has an accuracy' do
        expect(address.accuracy).to eq(1)
      end

      it 'has an accuracy_type' do
        expect(address.accuracy_type).to eq("rooftop")
      end
    end

    context 'with additional fields' do
      subject(:address) do
        VCR.use_cassette('geocode_with_fields') do
          geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[cd118 stateleg-next school timezone]).best
        end
      end

      it 'has congressional districts' do
        address.congressional_districts.each do |district|
          expect(district).to be_a(Geocodio::CongressionalDistrict)
        end
      end

      it 'has house districts' do
        expect(address.house_districts).to be_a(Array)
        expect(address.house_districts.size).to eq(1)
        expect(address.house_districts.first).to be_a(Geocodio::StateLegislativeDistrict)
      end

      it 'has senate districts' do
        expect(address.senate_districts).to be_a(Array)
        expect(address.senate_districts.size).to eq(1)
        expect(address.senate_districts.first).to be_a(Geocodio::StateLegislativeDistrict)
      end

      it 'has a unified school district' do
        expect(address.unified_school_district).to be_a(Geocodio::SchoolDistrict)
      end

      it 'could have an elementary school district' do
        expect(address.elementary_school_district).to be_nil
      end

      it 'could have a secondary school district' do
        expect(address.secondary_school_district).to be_nil
      end

      it 'has a timezone' do
        expect(address.timezone).to be_a(Geocodio::Timezone)
      end
    end
  end
end
