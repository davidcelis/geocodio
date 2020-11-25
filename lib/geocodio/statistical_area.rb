module Geocodio
  class StatisticalArea
    attr_reader :name
    attr_reader :area_code
    attr_reader :type

    def initialize(payload = {})
      @name       = payload['name']
      @area_code  = payload['area_code']
      @type       = payload['type']
    end
  end
end
