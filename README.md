# WorldpayCnp

A Ruby library for the Worldpay cnpAPI. Just a simple interface for creating transactions as a Ruby hash to XML and back. So no real request objects. Since the cnpAPI uses camelCase, this library will handle converting to and from snake_case for you.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'worldpay_cnp'
```

And then run `bundle install` or install directly with `gem install worldpay_cnp`.

## Usage

### Client Configuration

Create and configure a client with your API authentication.

```ruby
client = WorldpayCnp::Client.new(
  username: "YOUR_USERNAME",
  password: "YOUR_PASSWORD",
  merchant_id: "YOUR_MERCHANT_ID",
  # Below are options with their default values
  version: "12.8",
  environment: :prelive,
  timeout: nil, # with an integer, it is in seconds
  proxy: nil,
  xml_namspace: "http://www.vantivcnp.com/schema",
  xml_request_root: "cnpOnlineRequest"
)
```

#### Using A Proxy

A client can be configured with a proxy.

```ruby
WorldpayCnp::Client.new(
  # ...other options
  proxy: {
    host: "127.0.0.1",
    port: 5000,
    username: "username",
    password: "password",
  }
)
```

At a minimum, just the `host` and `port` are required to use a proxy.

### Making Requests

Make an API request with a payload in the structure documented by the cnpAPI but **using snake_case**. The request payload will be **converted to camelCase** for you.

Since generating part of the request body (root and authentication elements) is taken care of, we just specify the child element. For example, when creating a Sale transaction, it would look like:

```ruby
client.create_transaction(
  sale: {
    "@id": "123",
    "@report_group": "Default Report Group",
    order_id: "456"
    amount: "1000",
    order_source: "ecommerce",
    card: {
      type: "VI",
      number: "4457010000000009",
      exp_date: "1025",
      card_validation_num: "349",
    }
  }
)
```

Keys prefixed with "@" will be serialized to an XML attribute, while all others become XML elements.

The cnpAPI enforces the order of XML elements, so the hash keys provided must be in the same order.

For now, the library only supports cnpAPI online requests. No batch requests.

### Handling Responses

The response is an underlying hash **in snake_case** form. No typed response objects. So considering the earlier Sale request example, we can use `dig` to retrieve specific values.

```ruby
response.status_code
# => 200
response.dig(:sale_response, :response)
# => "000"
response.dig(:sale_response, :message)
# => "Approved"
```

The response data starts with the value of the root XML element (attributes included) so no need to do lookups with the root XML key.

Since the cnpAPI still returns a HTTP 200 response for errors (the XML root `response` attribute value is 1 through 5) a `WorldpayCnp::Error::InvalidFormatError` will be raised with the included response code and message.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment with methods `authenticated_client` and `sandbox_client` already available.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jackpocket/worldpay_cnp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/jackpocket/worldpay_cnp/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the WorldpayCnp project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jackpocket/worldpay_cnp/blob/master/CODE_OF_CONDUCT.md).
