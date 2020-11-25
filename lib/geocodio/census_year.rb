require 'geocodio/place'
require 'geocodio/statistical_area'

module Geocodio
  class CensusYear
    attr_reader :census_year
    attr_reader :state_fips
    attr_reader :county_fips
    attr_reader :tract_code
    attr_reader :block_code
    attr_reader :block_group
    attr_reader :full_fips
    attr_reader :place
    attr_reader :metro_micro_statistical_area
    attr_reader :combined_statistical_area
    attr_reader :metropolitan_division
    attr_reader :source

    alias :msa :metro_micro_statistical_area
    alias :csa :combined_statistical_area

    def initialize(payload = {})
      @census_year = payload['census_year']
      @state_fips =  payload['state_fips']
      @county_fips = payload['county_fips']
      @tract_code =  payload['tract_code']
      @block_code =  payload['block_code']
      @block_group = payload['block_group']
      @full_fips =   payload['full_fips']
      @source =      payload['source']

      if payload['place']
        @place = Place.new(payload['place'])
      end

      if payload['metro_micro_statistical_area']
        @metro_micro_statistical_area = StatisticalArea.new(payload['metro_micro_statistical_area'])
      end

      if payload['combined_statistical_area']
        @combined_statistical_area = StatisticalArea.new(payload['combined_statistical_area'])
      end

      if payload['metropolitan_division']
        @metropolitan_division = StatisticalArea.new(payload['metropolitan_division'])
      end
    end
  end
end
