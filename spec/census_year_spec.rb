require 'spec_helper'

describe Geocodio::CensusYear do
  let(:geocodio) { Geocodio::Client.new }

  subject(:census) do
    VCR.use_cassette('geocode_with_fields') do
      geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[cd stateleg school census timezone]).best.census.latest
    end
  end

  it 'has a census_year' do
    expect(census.census_year).to eql(2019)
  end

  it 'has a state_fips' do
    expect(census.state_fips).to eq('06')
  end

  it 'has a county_fips' do
    expect(census.county_fips).to eq('06037')
  end

  it 'has a tract_code' do
    expect(census.tract_code).to eq('463700')
  end

  it 'has a block_code' do
    expect(census.block_code).to eq('2001')
  end

  it 'has a block_group' do
    expect(census.block_group).to eq('2')
  end

  it 'has a full_fips' do
    expect(census.full_fips).to eq('060374637002001')
  end

  it 'has a place' do
    expect(census.place).to be_a(Geocodio::Place)
  end

  it 'has a metro_micro_statistical_area' do
    expect(census.metro_micro_statistical_area).to be_a(Geocodio::StatisticalArea)
    expect(census.msa).to be(census.metro_micro_statistical_area)
  end

  it 'has a combined_statistical_area' do
    expect(census.combined_statistical_area).to be_a(Geocodio::StatisticalArea)
    expect(census.csa).to be(census.combined_statistical_area)
  end

  it 'has a metropolitan_division' do
    expect(census.metropolitan_division).to be_a(Geocodio::StatisticalArea)
  end

  it 'has a source' do
    expect(census.source).to eq('US Census Bureau')
  end

end
