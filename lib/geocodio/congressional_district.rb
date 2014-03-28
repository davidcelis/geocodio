module Geocodio
  class CongressionalDistrict
    attr_reader :name
    attr_reader :district_number
    attr_reader :congress_number

    def initialize(payload = {})
      @name            = payload['name']
      @district_number = payload['district_number'].to_i
      @congress_number = payload['congress_number'].to_i
      @congress_years  = payload['congress_years']
    end

    def congress_years
      first, last = @congress_years.split('-').map(&:to_i)
      first..last
    end
  end
end
