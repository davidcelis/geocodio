require 'geocodio/congressional_district'
require 'geocodio/school_district'
require 'geocodio/state_legislative_district'
require 'geocodio/timezone'

module Geocodio
  class Address
    attr_reader :number, :predirectional, :street, :suffix, :city, :state, :zip, :county

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
    attr_reader :formatted_address

    def initialize(payload = {})
      set_attributes(payload['address_components']) if payload['address_components']
      set_coordinates(payload['location'])          if payload['location']
      set_additional_fields(payload['fields'])      if payload['fields']

      @accuracy          = payload['accuracy']
      @formatted_address = payload['formatted_address']
    end

    # Formats the address in the standard way.
    #
    # @return [String] a formatted address
    def to_s
      @formatted_address
    end

    private

    def set_attributes(attributes)
      @number         = attributes['number']
      @predirectional = attributes['predirectional']
      @street         = attributes['street']
      @suffix         = attributes['suffix']
      @city           = attributes['city']
      @state          = attributes['state']
      @zip            = attributes['zip']
      @county         = attributes['county']
    end

    def set_coordinates(coordinates)
      @latitude  = coordinates['lat']
      @longitude = coordinates['lng']
    end

    def set_additional_fields(fields)
      set_congressional_district(fields['congressional_district'])     if fields['congressional_district']
      set_legislative_districts(fields['state_legislative_districts']) if fields['state_legislative_districts']
      set_school_districts(fields['school_districts'])                 if fields['school_districts']
      set_timezone(fields['timezone'])                                 if fields['timezone']
    end

    def set_congressional_district(district)
      return if district.empty?

      @congressional_district = CongressionalDistrict.new(district)
    end

    def set_legislative_districts(districts)
      return if districts.empty?

      @house_district = StateLegislativeDistrict.new(districts['house'])
      @senate_district = StateLegislativeDistrict.new(districts['senate'])
    end

    def set_school_districts(schools)
      return if schools.empty?

      if schools['unified']
        @unified_school_district = SchoolDistrict.new(schools['unified'])
      else
        @elementary_school_district = SchoolDistrict.new(schools['elementary'])
        @secondary_school_district = SchoolDistrict.new(schools['secondary'])
      end
    end

    def set_timezone(timezone)
      return if timezone.empty?

      @timezone = Timezone.new(timezone)
    end

    def <=>(address)
      return -1 if self.accuracy <  address.accuracy
      return  0 if self.accuracy == address.accuracy
      return  1 if self.accuracy >  address.accuracy
    end
  end
end
