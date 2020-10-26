RSpec.describe WorldpayCnp::XML do

  describe ".parse" do
    it "parses XML (string) to a hash" do
      hash = described_class.parse(fixture_file("sale_sample.xml").read)

      expect(hash).to eq(
        'cnpOnlineRequest' => {
          'version' => '12.8',
          'merchantId' => '1',
          'authentication' => {
            'user' => 'username',
            'password' => 'password'
          },
          'sale' => {
            'id' => "test-123",
            'reportGroup' => 'Default Report Group',
            'orderId' => "test-456",
            'amount' => '1000',
            'orderSource' => 'ecommerce',
            'card' => {
              'type' => 'VI',
              'number' =>'4457010000000009',
              'expDate' =>'1025',
              'cardValidationNum' => '349',
            }
          }
        }
      )
    end
  end

  describe ".serialize" do
    it "serializes a hash into XML (string)" do
      hash = {
        'cnpOnlineRequest' => {
          '@xmlns': 'http://www.vantivcnp.com/schema',
          '@version' => '12.8',
          '@merchantId' => '1',
          'authentication' => {
            'user' => 'username',
            'password' => 'password'
          },
          'sale' => {
            '@id' => "test-123",
            '@reportGroup' => 'Default Report Group',
            'orderId' => "test-456",
            'amount' => '1000',
            'orderSource' => 'ecommerce',
            'card' => {
              'type' => 'VI',
              'number' => '4457010000000009',
              'expDate' => '1025',
              'cardValidationNum' => '349',
            }
          }
        }
      }

      expect(described_class.serialize(hash)).to eq fixture_file("sale_sample.xml").read
    end
  end

end
