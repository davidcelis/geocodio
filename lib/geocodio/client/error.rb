module Geocodio
  class Client
    class Error < RuntimeError
      attr_reader :response

      def initialize(response)
        @response, @json = response, JSON.parse(response.body)
      end

      def body() @json end
      def message() body['error'] end
      alias :error :message
    end
  end
end
