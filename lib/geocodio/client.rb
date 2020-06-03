require 'net/http'
require 'json'
require 'cgi'

require 'geocodio/client/error'
require 'geocodio/client/response'
require 'geocodio/utils'

module Geocodio
  class Client
    include Geocodio::Utils

    CONTENT_TYPE = 'application/json'
    METHODS = {
      :get    => Net::HTTP::Get,
      :post   => Net::HTTP::Post,
      :put    => Net::HTTP::Put,
      :delete => Net::HTTP::Delete
    }
    HOST = 'api.geocod.io'
    BASE_PATH = '/v1.6'
    PORT = 80

    def initialize(api_key = ENV['GEOCODIO_API_KEY'])
      @api_key = api_key
    end

    # Geocodes one or more addresses. If one address is specified, a GET request
    # is submitted to http://api.geocod.io/v1/geocode. Multiple addresses will
    # instead submit a POST request.
    #
    # @param [Array<String>] addresses one or more String addresses
    # @param [Hash] options an options hash
    # @option options [Array] :fields a list of option fields to request (possible: "cd" or "cd113", "stateleg", "school", "timezone")
    # @return [Geocodio::Address, Array<Geocodio::AddressSet>] One or more Address Sets
    def geocode(addresses, options = {})
      if addresses.size < 1
        raise ArgumentError, 'You must provide at least one address to geocode.'
      elsif addresses.size == 1
        geocode_single(addresses.first, options)
      else
        geocode_batch(addresses, options)
      end
    end

    # Reverse geocodes one or more pairs of coordinates. Coordinate pairs may be
    # specified either as a comma-separated "latitude,longitude" string, or as
    # a Hash with :lat/:latitude and :lng/:longitude keys. If one pair of
    # coordinates is specified, a GET request is submitted to
    # http://api.geocod.io/v1/reverse. Multiple pairs of coordinates will
    # instead submit a POST request.
    #
    # @param [Array<String>, Array<Hash>] coordinates one or more pairs of coordinates
    # @param [Hash] options an options hash
    # @option options [Array] :fields a list of option fields to request (possible: "cd" or "cd113", "stateleg", "school", "timezone")
    # @return [Geocodio::Address, Array<Geocodio::AddressSet>] One or more Address Sets
    def reverse_geocode(coordinates, options = {})
      if coordinates.size < 1
        raise ArgumentError, 'You must provide coordinates to reverse geocode.'
      elsif coordinates.size == 1
        reverse_geocode_single(coordinates.first, options)
      else
        reverse_geocode_batch(coordinates, options)
      end
    end
    alias :reverse :reverse_geocode

    # Sends a GET request to http://api.geocod.io/v1/parse to correctly dissect
    # an address into individual parts. As this endpoint does not do any
    # geocoding, parts missing from the passed address will be missing from the
    # result.
    #
    # @param address [String] the full or partial address to parse
    # @return [Geocodio::Address] a parsed and formatted Address
    def parse(address, options = {})
      params, options = normalize_params_and_options(options)
      params[:q] = address

      Address.new get('/parse', params, options).body
    end

    private

      METHODS.each do |method, _|
        define_method(method) do |path, params = {}, options = {}|
          request method, path, options.merge(params: params)
        end
      end

      def geocode_single(address, options = {})
        params, options = normalize_params_and_options(options)
        params[:q] = address

        response  = get '/geocode', params, options
        addresses, input = parse_results(response)

        AddressSet.new(address, *addresses, input: input)
      end

      def reverse_geocode_single(pair, options = {})
        params, options = normalize_params_and_options(options)
        pair = normalize_coordinates(pair)
        params[:q] = pair

        response  = get '/reverse', params, options
        addresses, input = parse_results(response)

        AddressSet.new(pair, *addresses, input: input)
      end

      def geocode_batch(addresses, options = {})
        params, options = normalize_params_and_options(options)
        options[:body] = addresses

        response = post '/geocode', params, options

        parse_nested_results(response)
      end

      def reverse_geocode_batch(pairs, options = {})
        params, options = normalize_params_and_options(options)
        options[:body] = pairs.map { |pair| normalize_coordinates(pair) }

        response = post '/reverse', params, options

        parse_nested_results(response)
      end

      def request(method, path, options)
        path += "?api_key=#{@api_key}"

        if params = options[:params] and !params.empty?
          q = params.map { |k, v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}" }
          path += "&#{q.join('&')}"
        end

        req = METHODS[method].new(BASE_PATH + path, 'Accept' => CONTENT_TYPE)

        if options.key?(:body)
          req['Content-Type'] = CONTENT_TYPE
          req.body = options[:body] ? JSON.dump(options[:body]) : ''
        end

        http = Net::HTTP.new HOST, PORT
        http.read_timeout = options[:timeout] if options[:timeout]
        res  = http.start { http.request(req) }

        case res
        when Net::HTTPSuccess
          return Response.new(res)
        else
          raise Error, res
        end
      end
  end
end
