RSpec.describe WorldpayCnp::Client do

  describe "#config" do
    it "returns config object" do
      expect(authenticated_client.config).to be_instance_of WorldpayCnp::Configuration
    end
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
            card: {
              type: 'VI',
              number: '4457010000000009',
              exp_date: '1025',
              card_validation_num: '349',
            }
          }
        )
      end

      expect(response.status_code).to eq 200
      expect(response.dig(:response)).to eq "0" # means valid format
      expect(response.dig(:sale_response, :response)).to eq "000"
      expect(response.dig(:sale_response, :message)).to eq "Approved"
      expect(response.dig(:sale_response, :cnp_txn_id)).to match(TRANSACTION_ID_REGEX)
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
              card: {
                type: 'VI',
                number: '4457010000000009',
                exp_date: '1025',
                card_validation_num: '349',
              }
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
