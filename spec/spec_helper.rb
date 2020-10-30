require "bundler/setup"
require "dotenv/load"
require "worldpay_cnp"
require "vcr"
require "webmock/rspec"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random
end

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.default_cassette_options = { record: (ENV['RECORD_MODE'] || :once).to_sym }
  c.filter_sensitive_data('{USERNAME}') { ENV['USERNAME'] }
  c.filter_sensitive_data('{PASSWORD}') { ENV['PASSWORD'] }
  c.filter_sensitive_data('{MERCHANT_ID}') { ENV['MERCHANT_ID'] }
end

TRANSACTION_ID_REGEX = /\d{1,19}/

def authenticated_client(**options)
  WorldpayCnp::Client.new(
    username: ENV["USERNAME"],
    password: ENV["PASSWORD"],
    merchant_id: ENV["MERCHANT_ID"],
    **options
  )
end

def fixture_file(name)
  File.new(File.expand_path("../fixtures/#{name}", __FILE__))
end

def random_alphanumeric_id
  "test-#{SecureRandom.alphanumeric(20)}"
end
