# Geocodio [![Build Status](https://travis-ci.org/davidcelis/geocodio.png?branch=master)](https://travis-ci.org/davidcelis/geocodio) [![Coverage Status](https://coveralls.io/repos/davidcelis/geocodio/badge.png)](https://coveralls.io/r/davidcelis/geocodio) [![Code Climate](https://codeclimate.com/github/davidcelis/geocodio.png)](https://codeclimate.com/github/davidcelis/geocodio)

Geocodio is a lightweight Ruby wrapper around the [geocod.io][geocod.io] API.

## Installation

In your Gemfile:

```ruby
gem 'geocodio'
```

## Usage

The point of entry to geocod.io's API is the `Geocodio::Client` class. Initialize
one by passing your API key or allowing the initializer to automatically use
the `GEOCODIO_API_KEY` environment variable:

```ruby
geocodio = Geocodio::Client.new('0123456789abcdef')

# Or, if you've set GEOCODIO_API_KEY in your environment:
geocodio = Geocodio::Client.new
```

### Geocoding

The `Geocodio::Client#geocode` method is used to request coordinates and expanded information on one or more addresses. It accepts an array of addresses and an options hash. If more than one address is provided, `#geocode` will use Geocodio's batch endpoint behind the scenes. It is possible for a geocoding request to yield multiple results with varying degrees of accuracy, so the `geocode` method will always return one `Geocodio::AddressSet` for each query made:

```ruby
results = geocodio.geocode(['1 Infinite Loop, Cupertino, CA 95014'])
# => #<Geocodio::AddressSet:0x007fdf23a07f80 @query="1 Infinite Loop, Cupertino, CA 95014", @addresses=[...]>
```

AddressSets are enumerable, so you can iterate over each result and perform operations on the addresses:

```ruby
results.each { |address| puts address }
```

If you just want the most accurate result, use the `#best` convenience method:

```ruby
address = results.best
# => #<Geocodio::Address:0x007fb062e7fb20 @number="1", @street="Infinite", @suffix="Loop", @city="Monta Vista", @state="CA", @zip="95014", @latitude=37.331669, @longitude=-122.03074, @accuracy=1, @formatted_address="1 Infinite Loop, Monta Vista CA, 95014">

puts address
# => 1 Infinite Loop, Cupertino CA, 95014

puts address.latitude # or address.lat
# => 37.331669

puts address.longitude # or address.lng
# => -122.03074
```

To perform a batch geocoding operation as mentioned earlier, simply add more addresses to the passed array:

```ruby
result_sets = geocodio.geocode(['1 Infinite Loop, Cupertino, CA 95014', '54 West Colorado Boulevard, Pasadena, CA 91105'])
# => [#<Geocodio::AddressSet:0x007fdf23a07f80 @query="1 Infinite Loop, Cupertino, CA 95014", @addresses=[...]>, #<Geocodio::AddressSet:0x007fdf23a07f80 @query="54 West Colorado Boulevard, Pasadena, CA 91105", @addresses=[...]>]

cupertino = result_sets.first.best
# => #<Geocodio::Address:0x007fb062e7fb20 @number="1", @street="Infinite", @suffix="Loop", @city="Monta Vista", @state="CA", @zip="95014", @latitude=37.331669, @longitude=-122.03074, @accuracy=1, @formatted_address="1 Infinite Loop, Monta Vista CA, 95014">
```

### Reverse Geocoding

The interface to reverse geocoding is very similar to geocoding. Use the `Geocodio::Client#reverse_geocode` method (aliased to `Geocodio::Client#reverse`) with one or more pairs of coordinates:

```ruby
addresses = geocodio.reverse_geocode(['37.331669,-122.03074'])
# => #<Geocodio::AddressSet:0x007fdf23a07f80 @query="1 Infinite Loop, Cupertino, CA 95014", @addresses=[...]>

address_sets = geocodio.reverse_geocode(['37.331669,-122.03074', '34.145760590909,-118.15204363636'])
# => [#<Geocodio::AddressSet:0x007fdf23a07f80 @query="1 Infinite Loop, Cupertino, CA 95014", @addresses=[...]>, #<Geocodio::AddressSet:0x007fdf23a07f80 @query="54 West Colorado Boulevard, Pasadena, CA 91105", @addresses=[...]>]
```

Coordinate pairs can also be specified as hashes:

```ruby
address_sets = geocodio.reverse_geocode([{ lat: 37.331669, lng: -122.03074 }, { latitude: 34.145760590909, longitude: -118.15204363636 }])
# => [#<Geocodio::AddressSet:0x007fdf23a07f80 @query="1 Infinite Loop, Cupertino, CA 95014", @addresses=[...]>, #<Geocodio::AddressSet:0x007fdf23a07f80 @query="54 West Colorado Boulevard, Pasadena, CA 91105", @addresses=[...]>]
```

### Parsing

```ruby
address = geocodio.parse('1 Infinite Loop, Cupertino, CA 95014')
# => #<Geocodio::Address:0x007fa3c15f41c0 @number="1", @street="Infinite", @suffix="Loop", @city="Cupertino", @state="CA", @zip="95014", @accuracy=nil, @formatted_address="1 Infinite Loop, Cupertino CA, 95014">
```

Note that this endpoint performs no geocoding; it merely formats a single provided address according to geocod.io's standards.

### Additional fields

Geocodio supports retrieval of [additional fields][fields] when geocoding or reverse geocoding. To request these fields, pass an options hash to either `#geocode` or `#reverse_geocode`. Possible fields include `cd`, `stateleg`, `school`, `census`, and `timezone`:

```ruby
address = geocodio.geocode(['54 West Colorado Boulevard Pasadena CA 91105'], fields: %w[cd stateleg school census timezone]).best

address.congressional_districts
# => #<Geocodio::CongressionalDistrict:0x007fa3c15f41c0 @name="Congressional District 27" @district_number=27 @congress_number=113 @congress_years=2013..2015>

address.house_district
# => #<Geocodio::StateLegislativeDistrict:0x007fa3c15f41c0 @name="Assembly District 41" @district_number=41>

address.senate_district
# => #<Geocodio::StateLegislativeDistrict:0x007fa3c15f41c0 @name="State Senate District 25" @district_number=25>

address.unified_school_district # or .elementary_school_district and .secondary_school_district if not unified
# => #<Geocodio::SchoolDistrict:0x007fa3c15f41c0 @name="Pasadena Unified School District" @lea_code="29940" @grade_low="KG" @grade_high="12">

address.timezone
# => #<Geocodio::Timezone:0x007fa3c15f41c0 @name="PST" @utc_offset=-8 @observes_dst=true>
address.timezone.observes_dst?
# => true

address.census
# => {"2019"=>#<Geocodio::CensusYear:0x00007ff59a24a800 ...>}
address.census.years
# => ["2019"]
address.census.latest
# => #<Geocodio::CensusYear:0x00007ff59a24a800 @census_year=2019, @state_fips="06", @county_fips="06037", @tract_code="463700", @block_code="2001", @block_group="2", @full_fips="060374637002001", @source="US Census Bureau", @place, @metro_micro_statistical_area, @combined_statistical_area, @metropolitan_division>
address.census.latest.place
# => #<Geocodio::Place:0x00007ff59a24a7b0 @name="Pasadena", @fips="0656000">
address.census.latest.metro_micro_statistical_area # or the shorthand alias .msa
# => #<Geocodio::StatisticalArea:0x00007ff59a24a788 @name="Los Angeles-Long Beach-Anaheim, CA", @area_code="31080", @type="metropolitan">
address.census.latest.combined_statistical_area # or the shorthand alias .csa
# => #<Geocodio::StatisticalArea:0x00007ff59a24a738 @name="Los Angeles-Long Beach, CA", @area_code="348", @type=nil>
address.census.latest.metropolitan_division
# => #<Geocodio::StatisticalArea:0x00007ff59a24a710 @name="Los Angeles-Long Beach-Glendale, CA", @area_code="31084", @type=nil>
```

The `cd` field requests district information for the current congress (116th as of November 2020). Information for a specific congress can be retrieved by specifying `cd113`, `cd114`, ... `cd117` (see the [Geocod.io documentation][districts] for details). Similarly, the `census` field requests information for the most recent census year (2019 as of November 2020), but one or more specific vintages of census data can be retrieved by specifying `census2010`, `census2011`, ... `census2019` (see the [Geocod.io documentation][census] for details).

## Contributing

1. Fork it ( http://github.com/davidcelis/geocodio/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[geocod.io]: https://www.geocod.io/
[fields]: https://www.geocod.io/docs/?ruby#fields
[districts]: https://www.geocod.io/docs/?ruby#congressional-districts
[census]: https://www.geocod.io/docs/?ruby#census-block-tract-fips-codes-amp-msa-csa-codes
