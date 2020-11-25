require 'spec_helper'

describe Geocodio::Census do
  let(:geocodio) { Geocodio::Client.new }

  subject(:census) do
    VCR.use_cassette('geocode_with_census') do
      geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[census2010 census2019]).best.census
    end
  end

  it 'has years' do
    expect(census.years).to eq(%w[2010 2019])
  end

  it 'has latest' do
    expect(census.latest).to be_a(Geocodio::CensusYear)
    expect(census.latest.census_year).to eql(2019)
  end
end
