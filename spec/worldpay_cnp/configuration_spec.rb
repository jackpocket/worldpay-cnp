RSpec.describe WorldpayCnp::Configuration do

  describe 'defaults' do
    let(:config) { described_class.new }

    defaults = {
      environment: :sandbox,
      api_url: "https://www.testvantivcnp.com/sandbox/communicator/online",
      version: "12.8",
      xml_namespace: "http://www.vantivcnp.com/schema",
      xml_request_root: "cnpOnlineRequest"
    }

    defaults.each do |name, value|
      it "sets #{name} with default value" do
        expect(config.public_send(name)).to eq value
      end
    end
  end

  describe 'environments' do
    environments = [
      :sandbox,
      'sandbox',
      :prelive,
      'prelive',
      :production,
      'production'
    ]

    environments.each do |environment|
      it "sets API URL for #{environment.inspect} environment" do
        config = described_class.new(environment: environment)

        expect(config.environment).to eq environment
        expect(config.api_url.empty?).to eq false
        expect(config.api_url).to eq described_class::ENVIRONMENTS[environment.to_sym]
      end
    end
  end

  describe 'with custom values set' do
    custom_options = {
      username: "username",
      password: "password",
      merchant_id: "123456",
      version: "8.22",
      timeout: 30, # in seconds
      proxy: {
        host: "127.0.0.1",
        port: 5000
      },
      xml_namespace: "litleOnlineRequest",
      xml_request_root: "http://www.litle.com/schema"
    }

    custom_options.each do |name, value|
      it "sets #{name} config with #{value.inspect}" do
        config = described_class.new(**{name => value})
        expect(config.public_send(name)).to eq value
      end
    end
  end

end
