require 'spec_helper'

describe Geocodio::StateLegislativeDistrict do
  let(:geocodio) { Geocodio::Client.new }

  subject(:district) do
    VCR.use_cassette('geocode_with_fields') do
      geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[cd stateleg school timezone]).best.house_district
    end
  end

  it 'has a name' do
    expect(district.name).to eq("Assembly District 41")
  end

  it 'has a district_number' do
    expect(district.district_number).to eq(41)
  end
end
