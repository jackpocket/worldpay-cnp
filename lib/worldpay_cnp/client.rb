module WorldpayCnp
  class Client

    attr_reader :config

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [WorldpayCnp::Client]
    def initialize(**options)
      @config = Configuration.new(**options)
    end

    def create_transaction(data)
      api_client.perform_post(@config.api_url, build_request_body(data))
    end

    private

    def api_client
      @api_client ||= ApiClient.new(@config)
    end

    def build_request_body(data)
      {
        @config.xml_request_root => {
          '@xmlns' => @config.xml_namespace,
          '@version' => @config.version,
          '@merchantId' => @config.merchant_id,
          'authentication' => {
            'user' => @config.username,
            'password' => @config.password
          }
        }.merge(data)
      }
    end

  end
end
