module Geocodio
  class Address
    attr_accessor :number
    attr_accessor :predirectional
    attr_accessor :street
    attr_accessor :suffix
    attr_accessor :city
    attr_accessor :state
    attr_accessor :zip

    attr_accessor :latitude
    attr_accessor :longitude
    alias :lat :latitude
    alias :lng :longitude

    # How accurage geocod.io deemed this result to be given the original query.
    #
    # @return [Float] a number between 0 and 1
    attr_accessor :accuracy

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

      @accuracy = payload['accuracy']

      @formatted_address = payload['formatted_address']
    end

    # Formats the address in the standard way.
    #
    # @return [String] a formatted address
    def to_s
      @formatted_address
    end
  end
end
