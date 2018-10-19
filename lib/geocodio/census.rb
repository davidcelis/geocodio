module Geocodio
  class Census
    attr_reader :state_fips
    attr_reader :county_fips
    attr_reader :place_fips
    attr_reader :tract_code
    attr_reader :block_group
    attr_reader :block_code
    attr_reader :census_year
    
    def initialize(payload = {})
      @state_fips   = payload['state_fips']
      @county_fips  = payload['county_fips']
      @place_fips   = payload['place_fips']
      @tract_code   = payload['tract_code']
      @block_group  = payload['block_group']
      @block_code   = payload['block_code']
      @census_year  = payload['census_year']
    end
  end
end
