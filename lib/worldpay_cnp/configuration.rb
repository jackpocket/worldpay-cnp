module WorldpayCnp
  class Configuration
    ENVIRONMENTS = {
      sandbox: "https://www.testvantivcnp.com/sandbox/communicator/online",
      prelive: "https://payments.vantivprelive.com/vap/communicator/online",
      production: "https://payments.vantivcnp.com/vap/communicator/online"
    }.freeze

    attr_reader :environment,
      :username,
      :password,
      :merchant_id,
      :version,
      :timeout,
      :proxy,
      :xml_namespace,
      :xml_request_root

    def initialize(**options)
      set_defaults
      set_config(options)
    end

    def api_url
      @api_url ||= ENVIRONMENTS[@environment.to_sym]
    end

    private

    def set_defaults
      @environment = :prelive
      @version = "12.8"
      @xml_namespace = "http://www.vantivcnp.com/schema"
      @xml_request_root = "cnpOnlineRequest"
    end

    def set_config(options)
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end
end
