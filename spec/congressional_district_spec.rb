require 'spec_helper'

describe Geocodio::CongressionalDistrict do
  let(:geocodio) { Geocodio::Client.new }

  subject(:district) do
    VCR.use_cassette('geocode_with_fields') do
      geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[cd stateleg school timezone]).best.congressional_district
    end
  end

  it 'has a name' do
    expect(district.name).to eq("Congressional District 27")
  end

  it 'has a district_number' do
    expect(district.district_number).to eq(27)
  end

  it 'has a congress_number' do
    expect(district.congress_number).to eq(114)
  end

  it 'has a congress_years' do
    expect(district.congress_years).to eq(2015..2017)
  end

end
