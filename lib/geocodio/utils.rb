module Geocodio
  module Utils
    def parse_results(response)
      results   = response.body['results']
      input     = response.body.dig('input', 'formatted_address')
      [results.map { |result| Address.new(result) }, input]
    end

    def parse_nested_results(response)
      results = response.body['results']

      results = results.map do |result_set|
        addresses = Array(result_set['response']['results'])
        addresses.map! { |result| Address.new(result) }

        query = result_set['query']

        AddressSet.new(query, *addresses, input: result_set.dig('response', 'input', 'formatted_address'))
      end
    end

    def normalize_coordinates(coordinates)
      return coordinates unless coordinates.is_a?(Hash)
      coordinates.sort.map { |p| p[1] }.join(',')
    end

    def normalize_params_and_options(hash)
      hash = Hash[hash.map { |k, v| [k.to_sym, v] }]

      # The only supported parameter is fields
      params = hash.select { |k, _| [:fields].include?(k) }

      # Normalize this particular parameter to be a comma-separated string
      params[:fields] = params[:fields].join(',') if params[:fields]

      # The only supported option is `timeout`
      options = hash.select { |k, _| [:timeout].include?(k) }

      [params, options]
    end
  end
end
