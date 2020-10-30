RSpec.describe WorldpayCnp::Client do

  describe "#config" do
    it "returns config object" do
      expect(authenticated_client.config).to be_instance_of WorldpayCnp::Configuration
    end
  end

  let(:valid_card_attributes) do
    {
      type: 'VI',
      number: '4457010000000009',
      exp_date: '1025',
      card_validation_num: '349',
    }
  end

  describe "sale transactions" do
    it "creates a sale successfully" do
      response = VCR.use_cassette('sales/card/create_successful') do
        authenticated_client.create_transaction(
          sale: {
            '@id': random_alphanumeric_id, # max length is 36
            '@report_group': 'Default Report Group',
            order_id: random_alphanumeric_id, # max length is 25
            amount: '1000',
            order_source: 'ecommerce',
            card: valid_card_attributes
          }
        )
      end

      expect(response.status_code).to eq 200
      expect(response.dig(:response)).to eq "0" # means valid format
      expect(response.dig(:sale_response, :response)).to eq "000"
      expect(response.dig(:sale_response, :message)).to eq "Approved"
      expect(response.dig(:sale_response, :cnp_txn_id)).to match(TRANSACTION_ID_REGEX)
    end

    it "creates an apple pay sale successfully" do
      response = VCR.use_cassette('sales/apple_pay/create_successful') do
        authenticated_client.create_transaction(
          sale: {
            '@id': random_alphanumeric_id,
            '@report_group': 'Default Report Group',
            order_id: random_alphanumeric_id,
            amount: '1000',
            order_source: 'applepay',
            bill_to_address: {
              first_name: "John",
              last_name: "Smith",
              address_line_1: "8 W 40th St",
              address_line_2: "",
              city: "New York",
              state: "NY",
              zip: "10012",
              country: "US",
              email: "johnsmith@example.com",
              phone: "2016551000"
            },
            applepay: {
              # data: SecureRandom.base64(316),
              data: "eav3v8jTY2Ffn+r+gWaPGDdHF0eFhRCh0CkPdKefYFePN/vUSJWCynsolgEme+4z9yP//pQqSWVZ7j64Z7qOR47nV1UR3RSbv0e88HRE1mBcBt4BqPUqPynK/WedfzGFih8lbDEC3eQ2dG52xGLxtx8yhsjXYxHwuCk/SqtdPenQi7WoXTUOJIfxTI3Kl6bHaTNhRHUwJDWaPAadf8p8IrIHcDCDWE8mFMZsy5qyTYz8pNvDFOB4lrRd+I3ahouSEI+7sOA3IX+8FDDCPOWh64A2AsVb37t/IWh2+ue8c46KNoOAlL0/55GH2yPgeCwS1uExakSgEFE26Y5V3EeHcWBvlwQM2kCiJ9zwRhYCa8XtCP9ha4n0ktmLqEjmMonOaovNLq5Bc1j8tckFZ2LmwcVcRTUi6AHnuOIFpA==",
              header: {
                # ephemeral_public_key: SecureRandom.base64(92),
                ephemeral_public_key: "K6jmLKQ4kQx8DkfP5xiIb6vAv8ad9MYXnDno+8XCmHG5jZSUady6Ahez9Kc9ar/HYKPcyI7wxHK7stNkA8mSGkRljSpZdOvVk9eFZAhRZaLasOHo2knsOUG5iWI=",
                # public_key_hash: SecureRandom.base64(32),
                public_key_hash: "tZE9cgJRxHqouQ1rQC06JZ1KDRYg7nqk9L7wlafPmp0=",
                # transaction_id: SecureRandom.hex(32),
                transaction_id: "4c44eb217747940ec316d074e725befcac6065057bf9f9ba8f72b2f1a8ef1567"
              },
              # signature: SecureRandom.base64(2216),
              signature: "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",
              version: "EC_v1"
            }
          }
        )
      end

      expect(response.status_code).to eq 200
      expect(response.dig(:response)).to eq "0" # means valid format
      expect(response.dig(:sale_response, :response)).to eq "000"
      expect(response.dig(:sale_response, :message)).to eq "Approved"
    end

    it "fails when elements are in wrong order" do
      expect do
        VCR.use_cassette('sales/card/create_failed_wrong_element_order') do
          authenticated_client.create_transaction(
            sale: {
              amount: '1000', # this is in the wrong order to force an error
              '@id': random_alphanumeric_id,
              '@report_group': 'Default Report Group',
              order_id: random_alphanumeric_id,
              order_source: 'ecommerce',
              card: valid_card_attributes
            }
          )
        end
      end.to raise_error do |error|
        expect(error).to be_instance_of(WorldpayCnp::Error::InvalidFormatError)
        expect(error.response_code).to eq "1"
        expect(error.message).to match(/Error validating xml data against the schema on line 8\s+tag name \"amount\" is not allowed. Possible tag names are: \[cnpTxnId\],\[orderId\]/)
        expect(error.raw_response.strip.empty?).to eq false
      end
    end
  end

end
