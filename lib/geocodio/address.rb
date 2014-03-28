require 'geocodio/congressional_district'
require 'geocodio/school_district'
require 'geocodio/state_legislative_district'
require 'geocodio/timezone'

module Geocodio
  class Address
    attr_reader :number, :predirectional, :street, :suffix, :city, :state, :zip

    attr_reader :latitude, :longitude
    alias :lat :latitude
    alias :lng :longitude

    attr_reader :congressional_district, :house_district, :senate_district,
                :unified_school_district, :elementary_school_district,
                :secondary_school_district

    attr_reader :timezone

    # How accurate geocod.io deemed this result to be given the original query.
    #
    # @return [Float] a number between 0 and 1
    attr_reader :accuracy

    def initialize(payload = {})
      if payload['address_components']
        @number         = payload['address_components']['number']
        @predirectional = payload['address_components']['predirectional']
        @street         = payload['address_components']['street']
        @suffix         = payload['address_components']['suffix']
        @city           = payload['address_components']['city']
        @state          = payload['address_components']['state']
        @zip            = payload['address_components']['zip']
      end

      if payload['location']
        @latitude  = payload['location']['lat']
        @longitude = payload['location']['lng']
      end

      @accuracy          = payload['accuracy']
      @formatted_address = payload['formatted_address']

      return self unless fields = payload['fields']

      if fields['congressional_district'] && !fields['congressional_district'].empty?
        @congressional_district = CongressionalDistrict.new(fields['congressional_district'])
      end

      if fields['state_legislative_districts'] && !fields['state_legislative_districts'].empty?
        @house_district = StateLegislativeDistrict.new(fields['state_legislative_districts']['house'])
        @senate_district = StateLegislativeDistrict.new(fields['state_legislative_districts']['senate'])
      end

      if (schools = fields['school_districts']) && !schools.empty?
        if schools['unified']
          @unified_school_district = SchoolDistrict.new(schools['unified'])
        else
          @elementary_school_district = SchoolDistrict.new(schools['elementary'])
          @secondary_school_district = SchoolDistrict.new(schools['secondary'])
        end
      end

      if fields['timezone'] && !fields['timezone'].empty?
        @timezone = Timezone.new(fields['timezone'])
      end
    end

    # Formats the address in the standard way.
    #
    # @return [String] a formatted address
    def to_s
      @formatted_address
    end
  end
end
