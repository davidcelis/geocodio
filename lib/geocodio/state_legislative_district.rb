module Geocodio
  class StateLegislativeDistrict
    attr_accessor :name
    attr_accessor :district_number
    attr_accessor :proportion
    attr_accessor :ocd_id

    def initialize(payload = {})
      @name            = payload['name']
      @district_number = payload['district_number'].to_i
      @district_number = payload['district_number'] if @district_number == 0
      @proportion      = payload['proportion']
      @ocd_id          = payload['ocd_id']
    end
  end
end
