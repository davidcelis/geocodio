module Geocodio
  module Canadian
    class FederalElectoralDistrict < ElectoralDistrictBase
      attr_accessor :code
      
      def initialize(payload = {})
        super
        @code = payload['code']
      end
    end
  end
end
