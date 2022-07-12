require 'spec_helper'

describe Geocodio::Canadian do
  let(:geocodio) { Geocodio::Client.new }
  
  subject do
    VCR.use_cassette('canadian') do
      geocodio.geocode([
        '1 Infinite Loop Cupertino CA 95014',
        '356 Yonge St, Toronto, ON M5G, Canada',
        '3475 Bd Sainte-Anne, Beauport, QC G1E 3L5, Canada'
      ], fields: %w[timezone cd118 provriding riding stateleg-next]).map(&:best)
    end
  end

  let(:us_address)   { subject[0] }
  let(:ca_en_address){ subject[1] }
  let(:ca_fr_address){ subject[2] }

  it 'is a canadian address' do
    expect(ca_en_address).to be_canadian
    expect(ca_fr_address).to be_canadian
  end
  
  it "isn't a canadian address" do
    expect(us_address).to_not be_canadian
    expect(us_address.canadian).to be_nil
  end
  
  it 'has canadian federal electoral district' do
    expect(ca_en_address.canadian).to_not be_nil
    expect(ca_en_address.canadian.federal_electoral_district).to_not be_nil
    
    federal_district1 = ca_en_address.canadian.federal_electoral_district
    
    expect(federal_district1.code).to eq('35110')
    expect(federal_district1.name_english).to eq('University--Rosedale')
    expect(federal_district1.name_french).to eq('University--Rosedale')
    expect(federal_district1.ocd_id).to eq('ocd-division/country:ca/ed:35110-2013')
    expect(federal_district1.source).to eq('Statistics Canada')
    
    expect(ca_fr_address.canadian).to_not be_nil
    expect(ca_fr_address.canadian.federal_electoral_district).to_not be_nil
    
    federal_district2 = ca_fr_address.canadian.federal_electoral_district
    
    expect(federal_district2.code).to eq('24008')
    expect(federal_district2.name_english).to eq('Beauport--Limoilou')
    expect(federal_district2.name_french).to eq('Beauport--Limoilou')
    expect(federal_district2.ocd_id).to eq('ocd-division/country:ca/ed:24008-2013')
    expect(federal_district2.source).to eq('Statistics Canada')    
  end
  
  it 'has canadian provincial electoral district' do
    expect(ca_en_address.canadian).to_not be_nil
    expect(ca_en_address.canadian.provincial_electoral_district).to_not be_nil
    
    provincial_district1 = ca_en_address.canadian.provincial_electoral_district
    
    expect(provincial_district1.name_english).to eq('University - Rosedale')
    expect(provincial_district1.name_french).to eq('University - Rosedale')
    expect(provincial_district1.ocd_id).to eq('ocd-division/country:ca/province:on/ed:112-2015')
    expect(provincial_district1.source).to eq('Elections Ontario')
    
    expect(ca_fr_address.canadian).to_not be_nil
    expect(ca_fr_address.canadian.provincial_electoral_district).to_not be_nil
    
    provincial_district2 = ca_fr_address.canadian.provincial_electoral_district
    
    expect(provincial_district2.name_english).to eq('Montmorency')
    expect(provincial_district2.name_french).to eq('Montmorency')
    expect(provincial_district2.ocd_id).to eq('ocd-division/country:ca/province:qc/ed:742-2017')
    expect(provincial_district2.source).to eq("Contains open data granted under the Chief Electoral Officer's Open Data User Licence available at http://dgeq.org/en/. The fact of granting the licence in no way implies that the Chief Electoral Officer approves the use made of the open data.")    
  end

  
end
