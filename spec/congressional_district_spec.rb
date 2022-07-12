require 'spec_helper'

describe Geocodio::CongressionalDistrict do
  let(:geocodio) { Geocodio::Client.new }

  subject(:district) do
    VCR.use_cassette('geocode_with_fields') do
      geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[cd118 stateleg-next school timezone]).
        best.
        congressional_districts.
        first
    end
  end

  it 'has a name' do
    expect(district.name).to eq("Congressional District 28")
  end

  it 'has a district_number' do
    expect(district.district_number).to eq(28)
  end

  it 'has a congress_number' do
    expect(district.congress_number).to eq(118)
  end

  it 'has a congress_years' do
    expect(district.congress_years).to eq(2023..2025)
  end

  it 'has a proportion' do
    expect(district.proportion).to eq(1)
  end

  it 'has ocd_id' do
    expect(district.ocd_id).to eq('ocd-division/country:us/state:ca/cd:28')
  end


  it 'has current_legislators' do
    district.current_legislators.each do |legislator|
      expect(legislator).to be_a(Geocodio::Legislator)
    end
  end
end
