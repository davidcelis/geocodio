require 'spec_helper'

describe Geocodio::SchoolDistrict do
  let(:geocodio) { Geocodio::Client.new }

  subject(:district) do
    VCR.use_cassette('geocode_with_fields') do
      geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[cd stateleg school census timezone]).best.unified_school_district
    end
  end

  it 'has a name' do
    expect(district.name).to eq('Pasadena Unified School District')
  end

  it 'has a lea_code' do
    expect(district.lea_code).to eq('0629940')
  end

  it 'has a grade_low' do
    expect(district.grade_low).to eq('KG')
  end

  it 'has a grade_high' do
    expect(district.grade_high).to eq('12')
  end
end
