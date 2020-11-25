require 'spec_helper'

describe Geocodio::StateLegislativeDistrict do
  let(:geocodio) { Geocodio::Client.new }

  context 'typical numeric district' do
    subject(:district) do
      VCR.use_cassette('geocode_with_fields') do
        geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[cd stateleg school census timezone]).best.house_district
      end
    end

    it 'has a name' do
      expect(district.name).to eq("Assembly District 41")
    end

    it 'has a district_number' do
      expect(district.district_number).to eq(41)
    end
  end

  context 'Alaska non-numeric state district' do
    subject(:alaska_district) do
      VCR.use_cassette('alaska_geocode_with_fields') do
        geocodio.geocode(['4141 woronzof dr anchorage ak 99517'], fields: %w[cd stateleg]).best.senate_district
      end
    end

    it 'has a name' do
      expect(alaska_district.name).to eq("State Senate District K")
    end

    it 'has a district_number' do
      expect(alaska_district.district_number).to eq('K')
    end
  end
end
