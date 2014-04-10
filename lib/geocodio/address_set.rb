# AddressSet is a collection of Geocodio::Address objects that get returned from
# a query to geocod.io. Because one query can return multiple results, each with
# an accuracy, a collection to manage them is needed. Most of the time, the user
# should only need to use the #best method.
module Geocodio
  class AddressSet
    include Enumerable

    # Returns the query that retrieved this result set.
    #
    # @return [String] the original query
    attr_reader :query

    def initialize(query, *addresses)
      @query     = query
      @addresses = addresses
    end

    def each(&block)
      @addresses.each(&block)
    end

    # Returns the result that geocod.io deemed the most accurate for the query.
    #
    # @return [Geocodio::Address] the most accurate address
    def best
      max_by(&:accuracy)
    end

    # Returns the number of addresses contained in this result set.
    #
    # @return [Integer] the number of addresses
    def size
      @addresses.size
    end

    # Returns whether or not there are any addresses in this result set.
    #
    # @return [Boolean] if there were any results returned by Geocodio
    def empty?
      @addresses.empty?
    end
  end
end
