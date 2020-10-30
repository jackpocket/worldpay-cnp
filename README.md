# WorldpayCnp Ruby gem

[![Gem Version](https://badge.fury.io/rb/worldpay_cnp.svg)][gem]
![Test Suite](https://github.com/jackpocket/worldpay-cnp/workflows/Test%20Suite/badge.svg)

A Ruby library for the Worldpay cnpAPI with a simple interface for creating transactions as a Ruby hash to XML and back. So no real request objects. Since the cnpAPI uses camelCase, this library will handle converting to and from snake_case for you. While Worldpay has an official [CnpOnline Ruby SDK](https://github.com/Vantiv/cnp-sdk-for-ruby), they no longer support it.

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
  # These are the other available options with their default values
  version: "12.8",
  environment: :sandbox,
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

At a minimum, just the `host` and `port` fields are required to use a proxy.

### Making Requests

Make an API request with a payload in the structure and order documented by the cnpAPI but **using snake_case**. The request payload will be **converted to camelCase** internally before submission.

Since generating part of the request body is taken care of (e.g. the XML root and authentication elements) we just specify the child element. For example, when creating a Sale transaction, it would look like:

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

Any keys prefixed with "@" will be serialized to an XML attribute, while all others become XML elements. Note that this does not apply to responses.

**IMPORTANT**: The cnpAPI enforces the order of XML elements, so the hash keys provided must be declared in the same order as it would if it were XML.

For now, the library only supports cnpAPI online requests. No batch requests.

### Handling Responses

The generic response object is essentially an underlying hash **in snake_case** form. No typed response objects. So considering the earlier Sale request example, we can use `dig` to retrieve specific values from the response.

```ruby
response.status_code
# => 200
response.dig(:sale_response, :response)
# => "000"
response.dig(:sale_response, :message)
# => "Approved"
```

Note: The response data starts with **the value of** the root XML element (attributes included) so do not specify the root XML key as part of the lookup process.

Since the cnpAPI returns an HTTP 200 response for format errors, an `WorldpayCnp::Error::InvalidFormatError` **will be raised with the included parsed response code and message**. The response code comes from the XML root `response` attribute and can be a value of "1" through "5" (note: as a string value).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment with methods `authenticated_client` and `sandbox_client` already available.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jackpocket/worldpay_cnp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/jackpocket/worldpay_cnp/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the WorldpayCnp project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jackpocket/worldpay_cnp/blob/master/CODE_OF_CONDUCT.md).

[gem]: https://rubygems.org/gems/worldpay_cnp
