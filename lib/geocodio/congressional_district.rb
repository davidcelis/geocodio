require 'geocodio/legislator'

module Geocodio
  class CongressionalDistrict
    attr_reader :name
    attr_reader :district_number
    attr_reader :congress_number
    attr_reader :proportion
    attr_reader :current_legislators

    def initialize(payload = {})
      @name            = payload['name']
      @district_number = payload['district_number'].to_i
      @congress_number = payload['congress_number'].to_i
      @congress_years  = payload['congress_years']
      @proportion      = payload['proportion'].to_i

      @current_legislators = payload['current_legislators'].map do |legislator|
        Legislator.new(legislator)
      end
    end

    def congress_years
      first, last = @congress_years.split('-').map(&:to_i)
      first..last
    end
  end
end
