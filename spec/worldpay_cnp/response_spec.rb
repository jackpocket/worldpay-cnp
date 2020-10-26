RSpec.describe WorldpayCnp::Response do

  let(:sample_response) do
    described_class.new({ message: "Valid Format"}, 200, "<xml>...</xml>")
  end

  it "has a status_code" do
    expect(sample_response.status_code).to eq 200
  end

  it "returns a hash of response data" do
    expect(sample_response.to_h).to eq(message: "Valid Format")
  end

  it "delegates dig to data" do
    expect(sample_response.dig(:message)).to eq "Valid Format"
  end

  it "returns raw response body" do
    expect(sample_response.raw_response).to eq "<xml>...</xml>"
  end

end
