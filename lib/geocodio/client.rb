require 'net/http'
require 'json'
require 'cgi'

require 'geocodio/client/error'
require 'geocodio/client/response'

module Geocodio
  class Client
    CONTENT_TYPE = 'application/json'
    METHODS = {
      :get    => Net::HTTP::Get,
      :post   => Net::HTTP::Post,
      :put    => Net::HTTP::Put,
      :delete => Net::HTTP::Delete
    }
    HOST = 'api.geocod.io'
    BASE_PATH = '/v1'
    PORT = 80

    def initialize(api_key = ENV['GEOCODIO_API_KEY'])
      @api_key = api_key
    end

    # Geocodes one or more addresses. If one address is specified, a GET request
    # is submitted to http://api.geocod.io/v1/geocode. Multiple addresses will
    # instead submit a POST request.
    #
    # @param addresses [Array] one or more String addresses
    # @return [Geocodio::Address, Array<Geocodio::AddressSet>] One or more Address Sets
    def geocode(*addresses)
      addresses = addresses.first if addresses.first.is_a?(Array)

      if addresses.size < 1
        raise ArgumentError, 'You must provide at least one address to geocode.'
      elsif addresses.size == 1
        geocode_single(addresses.first)
      else
        geocode_batch(addresses)
      end
    end

    # Sends a GET request to http://api.geocod.io/v1/parse to correctly dissect
    # an address into individual parts. As this endpoint does not do any
    # geocoding, parts missing from the passed address will be missing from the
    # result.
    #
    # @param address [String] the full or partial address to parse
    # @return [Geocodio::Address] a parsed and formatted Address
    def parse(address)
      Address.new get('/parse', q: address).body
    end

    private

      METHODS.each do |method, _|
        define_method(method) do |path, params = {}, options = {}|
          request method, path, options.merge(params: params)
        end
      end

      def geocode_single(address)
        response  = get '/geocode', q: address
        results   = response.body['results']
        query     = response.body['input']['formatted_address']
        addresses = results.map { |result| Address.new(result) }

        AddressSet.new(query, *addresses)
      end

      def geocode_batch(addresses)
        response    = post '/geocode', {}, body: addresses
        result_sets = response.body['results']

        result_sets.map do |result_set|
          query     = result_set['response']['input']['formatted_address']
          results   = result_set['response']['results']
          addresses = results.map { |result| Address.new(result) }

          AddressSet.new(query, *addresses)
        end
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
