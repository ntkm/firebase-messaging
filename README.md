# Firebase::Messaging
Firebase Cloud Messaging HTTP protocol client for Ruby.
This is unofficial library.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'firebase-messaging'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install firebase-messaging

## Usage
```ruby
Firebase::Messaging.configure do |config|
  config.server_key = '***SERVER KEY***'
  config.logger = Rails.logger
  config.logger_level = :debug
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ntkm/firebase-messaging. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

