module Geocodio
  module Canadian
    class ElectoralDistrictBase
      attr_accessor :ocd_id
      attr_accessor :name_french
      attr_accessor :name_english
      attr_accessor :source

      def initialize(payload = {})
        @ocd_id          = payload['ocd_id']
        @name_english    = payload['name_english']
        @name_french     = payload['name_french']
        @source          = payload['source']
      end

      def name
        @name_english
      end
    end
  end
end
