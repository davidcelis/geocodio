module Geocodio
  class Place
    attr_reader :name
    attr_reader :fips

    def initialize(payload = {})
      @name = payload['name']
      @fips = payload['fips']
    end
  end
end
