RSpec.describe WorldpayCnp::ApiClient do

  def with_proxy_config(**config)
    described_class.new(WorldpayCnp::Configuration.new(**config))
  end

  def fake_request(api_client)
    fake_response = HTTP::Response.new(status: 200, version: '', body: '')
    expect_any_instance_of(HTTP::Client).to receive(:post).and_return(fake_response)
    api_client.perform_post("", {})
  end

  it "uses proxy host, port, username and password" do
    api_client = with_proxy_config(
      proxy: {
        host: "1.2.3.4",
        port: 1000,
        username: "username",
        password: "password"
      }
    )

    expect(HTTP).to receive(:via).with("1.2.3.4", 1000, "username", "password").and_call_original

    fake_request(api_client)
  end

  it "uses proxy host and port" do
    api_client = with_proxy_config(
      proxy: {
        host: "1.2.3.4",
        port: 1000
      }
    )

    expect(HTTP).to receive(:via).with("1.2.3.4", 1000).and_call_original

    fake_request(api_client)
  end

  it "does not use proxy by default" do
    api_client = with_proxy_config()

    expect(HTTP).to_not receive(:via)

    fake_request(api_client)
  end

  it "does not use proxy with empty hash" do
    api_client = with_proxy_config(proxy: {})

    expect(HTTP).to_not receive(:via)

    fake_request(api_client)
  end

end
