module Geocodio
  module Utils
    def parse_results(response)
      results   = response.body['results']
      addresses = results.map { |result| Address.new(result) }
    end

    def parse_nested_results(response)
      results = response.body['results']

      results.map do |result_set|
        addresses = Array(result_set['response']['results'])
        addresses.map! { |result| Address.new(result) }

        query = result_set['query']

        AddressSet.new(query, *addresses)
      end
    end

    def normalize_coordinates(coordinates)
      return coordinates unless coordinates.is_a?(Hash)
      coordinates.sort.map { |p| p[1] }.join(',')
    end
  end
end
