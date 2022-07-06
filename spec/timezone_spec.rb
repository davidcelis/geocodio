require 'spec_helper'

describe Geocodio::Timezone do
  let(:geocodio) { Geocodio::Client.new }

  subject(:timezone) do
    VCR.use_cassette('geocode_with_fields') do
      geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[cd118 stateleg-next school timezone]).best.timezone
    end
  end

  it 'has a name' do
    expect(timezone.name).to eq('America/Los_Angeles')
  end

  it 'has a utc_offset' do
    expect(timezone.utc_offset).to eq(-8)
  end

  it 'observes DST' do
    expect(timezone).to be_observes_dst
  end
end
