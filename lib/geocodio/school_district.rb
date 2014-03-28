module Geocodio
  class SchoolDistrict
    attr_reader :name
    attr_reader :lea_code
    attr_reader :grade_low
    attr_reader :grade_high

    def initialize(payload = {})
      @name       = payload['name']
      @lea_code   = payload['lea_code']
      @grade_low  = payload['grade_low']
      @grade_high = payload['grade_high']
    end
  end
end
