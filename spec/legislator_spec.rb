require 'spec_helper'

describe Geocodio::Legislator do
  let(:geocodio) { Geocodio::Client.new }

  subject(:legislator) do
    VCR.use_cassette('geocode_with_fields') do
      geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[cd stateleg school timezone]).
        best.
        congressional_districts.
        first.
        current_legislators.
        first
    end
  end

  it 'has a type' do
    expect(legislator.type).to eq('representative')
  end

  it 'has a name' do
    expect(legislator.name).to eq('Judy Chu')
  end

  it 'has a birthday' do
    expect(legislator.birthday).to eq(Date.new(1953, 07, 07))
  end

  it 'has a gender' do
    expect(legislator.gender).to eq('F')
  end

  it 'has a party' do
    expect(legislator.party).to eq('Democrat')
  end

  it 'has a url' do
    expect(legislator.url).to eq('https://chu.house.gov')
  end

  it 'has a address' do
    expect(legislator.address).to eq('2423 Rayburn HOB; Washington DC 20515-0527')
  end

  it 'has a phone' do
    expect(legislator.phone).to eq('202-225-5464')
  end

  it 'has a contact_form' do
    expect(legislator.contact_form).to be_nil
  end

  it 'has a rss_url' do
    expect(legislator.rss_url).to eq('http://chu.house.gov/rss.xml')
  end

  it 'has a twitter' do
    expect(legislator.twitter).to eq('RepJudyChu')
  end

  it 'has a facebook' do
    expect(legislator.facebook).to eq('RepJudyChu')
  end

  it 'has a youtube' do
    expect(legislator.youtube).to eq('RepJudyChu')
  end

  it 'has a youtube_id' do
    expect(legislator.youtube_id).to eq('UCfcbYOvdEXZNelM8T05nK-w')
  end

  it 'has a bioguide_id' do
    expect(legislator.bioguide_id).to eq('C001080')
  end

  it 'has a thomas_id' do
    expect(legislator.thomas_id).to eq('01970')
  end

  it 'has a opensecrets_id' do
    expect(legislator.opensecrets_id).to eq('N00030600')
  end

  it 'has a lis_id' do
    expect(legislator.lis_id).to be_nil
  end

  it 'has a cspan_id' do
    expect(legislator.cspan_id).to eq('92573')
  end

  it 'has a govtrack_id' do
    expect(legislator.govtrack_id).to eq('412379')
  end

  it 'has a votesmart_id' do
    expect(legislator.votesmart_id).to eq('16539')
  end

  it 'has a ballotpedia_id' do
    expect(legislator.ballotpedia_id).to eq('Judy Chu')
  end

  it 'has a washington_post_id' do
    expect(legislator.washington_post_id).to be_nil
  end

  it 'has a icpsr_id' do
    expect(legislator.icpsr_id).to eq('20955')
  end

  it 'has a wikipedia_id' do
    expect(legislator.wikipedia_id).to eq('Judy Chu')
  end
end
