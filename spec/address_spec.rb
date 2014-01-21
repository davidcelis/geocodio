require 'spec_helper'

describe Geocodio::Address do
  let(:geocodio) { Geocodio::Client.new }

  context 'when parsed' do
    subject(:address) do
      VCR.use_cassette('parse') do
        geocodio.parse('1 Infinite Loop Cupertino CA 95014')
      end
    end

    it 'has a number' do
      expect(address.number).to eq('1')
    end

    it 'has a street' do
      expect(address.street).to eq('Infinite')
    end

    it 'has a suffix' do
      expect(address.suffix).to eq('Loop')
    end

    it 'has a city' do
      expect(address.city).to eq('Cupertino')
    end

    it 'has a state' do
      expect(address.state).to eq('CA')
    end

    it 'has a zip' do
      expect(address.zip).to eq('95014')
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
  end

  context 'when geocoded' do
    subject(:address) do
      VCR.use_cassette('geocode') do
        geocodio.geocode('1 Infinite Loop Cupertino CA 95014').best
      end
    end

    it 'has a number' do
      expect(address.number).to eq('1')
    end

    it 'has a street' do
      expect(address.street).to eq('Infinite')
    end

    it 'has a suffix' do
      expect(address.suffix).to eq('Loop')
    end

    it 'has a city' do
      expect(address.city).to eq('Monta Vista')
    end

    it 'has a state' do
      expect(address.state).to eq('CA')
    end

    it 'has a zip' do
      expect(address.zip).to eq('95014')
    end

    it 'has a latitude' do
      expect(address.latitude).to eq(37.331669)
      expect(address.lat).to      eq(37.331669)
    end

    it 'has a longitude' do
      expect(address.longitude).to eq(-122.03074)
      expect(address.lng).to       eq(-122.03074)
    end

    it 'has an accuracy' do
      expect(address.accuracy).to eq(1)
    end
  end
end
