RSpec.describe WorldpayCnp::Error do

  describe ".from_http_response" do
    described_class::ERRORS_BY_STATUS.each do |status, klass|
      it "creates an #{klass} instance for #{status} status code" do
        error = described_class.from_http_response('', status)

        expect(error).to be_an_instance_of klass

        if (400..499).cover?(status)
          expect(error).to be_a WorldpayCnp::Error::ClientError
        end

        if (500..599).cover?(status)
          expect(error).to be_a WorldpayCnp::Error::ServerError
        end
      end
    end

    it "creates general error object if no match by status code" do
      error = described_class.from_http_response('', nil)

      expect(error).to be_an_instance_of WorldpayCnp::Error
    end

    it "sets a generic message with given status code" do
      error = described_class.from_http_response('', 500)

      expect(error.message).to eq "Service error (Status: 500)"
    end
  end

  describe "generic error" do
    let!(:error) do
      described_class.new("message", response_code: "1", raw_response: "<xml>...</xml>")
    end

    it "has a message" do
      expect(error.message).to eq "message"
    end

    it "has a response code" do
      expect(error.response_code).to eq "1"
    end

    it "has a raw response" do
      expect(error.raw_response).to eq "<xml>...</xml>"
    end
  end

end
