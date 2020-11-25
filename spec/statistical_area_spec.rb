require 'spec_helper'

describe Geocodio::StatisticalArea do
  let(:geocodio) { Geocodio::Client.new }

  context 'metro/micro statistical area' do
    subject(:msa) do
      VCR.use_cassette('geocode_with_fields') do
        geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[cd stateleg school census timezone]).best.census.latest.msa
      end
    end

    it 'has a name' do
      expect(msa.name).to eq("Los Angeles-Long Beach-Anaheim, CA")
    end

    it 'has an area_code' do
      expect(msa.area_code).to eq('31080')
    end

    it 'has a type' do
      expect(msa.type).to eq('metropolitan')
    end
  end

  context 'combined statistical area' do
    subject(:csa) do
      VCR.use_cassette('geocode_with_fields') do
        geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[cd stateleg school census timezone]).best.census.latest.csa
      end
    end

    it 'has a name' do
      expect(csa.name).to eq("Los Angeles-Long Beach, CA")
    end

    it 'has an area_code' do
      expect(csa.area_code).to eq('348')
    end
  end

  context 'metropolitan division' do
    subject(:metro_div) do
      VCR.use_cassette('geocode_with_fields') do
        geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[cd stateleg school census timezone]).best.census.latest.metropolitan_division
      end
    end

    it 'has a name' do
      expect(metro_div.name).to eq("Los Angeles-Long Beach-Glendale, CA")
    end

    it 'has an area_code' do
      expect(metro_div.area_code).to eq('31084')
    end
  end
end
