# Syllogism

Check if individual statements are well-formed formulas and if whole arguments are valid in in Aristotelian logic.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'syllogism'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install syllogism

## Usage

```ruby
# Individual statements:
Syllogism::Statement.parse('all 1s are numbers').tap do |invalid_statement|
  invalid_statement.wff? # => false
  invalid_statement.errors
  # => ["'1s' is an unknown atom", "'numbers' is an unknown atom"]
end

Syllogism::Statement.parse('all X is Y').tap do |valid_statement|
  valid_statement.wff? # => true
  valid_statement.errors # => []
end

# Entire arguments:
Syllogism['all P is S', 'j is P', 'j is S'].valid? # => true
Syllogism['no A is B', 'no C is A', 'no C is B'].valid? # => false

# Arguments with the same logical form are considered equivalent:
argument = Syllogism["all A is B", "some C is A", "some C is B"]
other_argument = Syllogism["all X is Y", "some Z is X", "some Z is Y"]

argument == other_argument # => true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jaysonvirissimo/syllogism.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
