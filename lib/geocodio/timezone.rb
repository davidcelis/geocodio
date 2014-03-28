module Geocodio
  class Timezone
    attr_reader :name
    attr_reader :utc_offset

    def initialize(payload = {})
      @name         = payload['name']
      @utc_offset   = payload['utc_offset']
      @observes_dst = payload['observes_dst']
    end

    def observes_dst?
      !!@observes_dst
    end
  end
end
