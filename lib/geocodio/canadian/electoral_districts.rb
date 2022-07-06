require 'geocodio/canadian/electoral_district_base'
require 'geocodio/canadian/federal_electoral_district'
require 'geocodio/canadian/provincial_electoral_district'

module Geocodio
  module Canadian
    class ElectoralDistricts
      attr_accessor :federal_electoral_district
      attr_accessor :provincial_electoral_district
      
      def initialize(riding, provincial_riding)

        if riding && riding.is_a?(Hash) && riding.size > 0
          @federal_electoral_district = FederalElectoralDistrict.new(riding)
        end
        
        if provincial_riding && provincial_riding.is_a?(Hash) && provincial_riding.size > 0
          @provincial_electoral_district = ProvincialElectoralDistrict.new(provincial_riding)
        end
      end
    end
  end
end
