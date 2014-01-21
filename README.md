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

The `Geocodio::Client#geocode` method is used to request coordinates and expanded information on one or more addresses. It is possible for a geocoding request to yield multiple results with varying degrees of accuracy, so the `geocode` method will always return one `Geocodio::AddressSet` for each query made:

```ruby
results = geocodio.geocode('1 Infinite Loop, Cupertino, CA 95014')
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

To perform a batch geocoding operation, simply pass multiple addresses to `Geocodio::Client#geocode`:

```ruby
result_sets = geocodio.geocode('1 Infinite Loop, Cupertino, CA 95014', '54 West Colorado Boulevard, Pasadena, CA 91105')
# => [#<Geocodio::AddressSet:0x007fdf23a07f80 @query="1 Infinite Loop, Cupertino, CA 95014", @addresses=[...]>, #<Geocodio::AddressSet:0x007fdf23a07f80 @query="54 West Colorado Boulevard, Pasadena, CA 91105", @addresses=[...]>]

cupertino = result_sets.first.best
# => #<Geocodio::Address:0x007fb062e7fb20 @number="1", @street="Infinite", @suffix="Loop", @city="Monta Vista", @state="CA", @zip="95014", @latitude=37.331669, @longitude=-122.03074, @accuracy=1, @formatted_address="1 Infinite Loop, Monta Vista CA, 95014">
```

### Parsing

```ruby
address = geocodio.parse('1 Infinite Loop, Cupertino, CA 95014')
# => #<Geocodio::Address:0x007fa3c15f41c0 @number="1", @street="Infinite", @suffix="Loop", @city="Cupertino", @state="CA", @zip="95014", @accuracy=nil, @formatted_address="1 Infinite Loop, Cupertino CA, 95014">
```

Note that this endpoint performs no geocoding; it merely formats a single provided address according to geocod.io's standards.

## Contributing

1. Fork it ( http://github.com/davidcelis/geocodio/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[geocod.io]: http://geocod.io/
