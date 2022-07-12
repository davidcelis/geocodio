module Geocodio
  module Canadian
    attr_reader :canadian
    
    def set_canadian_fields(riding, provincial_riding)
      @canadian = ElectoralDistricts.new(riding, provincial_riding)
    end

    def canadian?
      !!@canadian
    end

  end
end
