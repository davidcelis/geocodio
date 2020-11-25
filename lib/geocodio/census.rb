# Census is a hash of Geocodio::CensusYear objects returned from a query,
# indexed by census year represented as a string. Typically an individual
# object would be referenced by the #latest method.

require 'geocodio/census_year'

module Geocodio
  class Census < ::Hash

    def initialize(payload = {})
      super()
      replace Hash[payload.map { |year, data| [year, Geocodio::CensusYear.new(data)] }]
    end

    alias :years :keys

    # Returns census data for the most recent year retrieved.
    #
    # @return [Geocodio::CensusYear] data for the most recent year
    def latest
      return nil if empty?
      self[keys.max]
    end
  end
end
