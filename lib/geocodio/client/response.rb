require 'json'

module Geocodio
  class Client
    class Response
      attr_reader :body

      def initialize(response)
        @body = JSON.parse(response.body)
      end
    end
  end
end
