module WorldpayCnp
  class ApiClient
    HEADERS = {
      'Content-Type' => 'text/xml; charset=UTF-8',
      'User-Agent' => "WorldpayCnpRubyGem/#{WorldpayCnp::VERSION}",
      'X-Ruby-Version' => RUBY_VERSION,
      'X-Ruby-Platform' => RUBY_PLATFORM
    }

    INVALID_RESPONSE_VALUES = %w(1 2 3 4 5)

    using Refinements::CamelCase
    using Refinements::SnakeCase
    using Refinements::DeepSymbolizeKeys

    def initialize(config)
      @config = config
    end

    def perform_post(url, data)
      response = http_client.post(url, body: XML.serialize(data.to_camel_case))
      process_response(response)
    end

    protected

    def http_client
      client = with_proxy? ? HTTP.via(*proxy) : HTTP
      client.headers(HEADERS).timeout(@config.timeout || :null)
    end

    def with_proxy?
      !proxy.nil? && !proxy.empty?
    end

    def proxy
      @proxy ||= @config.proxy&.values_at(:host, :port, :username, :password)&.compact
    end

    def process_response(response)
      data = parse_response_body(response.to_s)

      if response.status.success?
        handle_invalid_format_error(data, response.to_s)
        Response.new(data, response.status.code, response.to_s)
      else
        raise Error.from_http_response(response.to_s, response.status.code)
      end
    end

    def parse_response_body(body)
      return {} if body.strip.empty?
      hash_from_xml(body)
    end

    def hash_from_xml(xml)
      result = XML.parse(xml)
      if root_key = result.keys.first
        result[root_key]&.to_snake_case&.deep_symbolize_keys
      end
    end

    def handle_invalid_format_error(hash, body)
      if INVALID_RESPONSE_VALUES.include?(hash.dig(:response))
        raise Error::InvalidFormatError.new(
          hash.dig(:message),
          response_code: hash.dig(:response),
          raw_response: body
        )
      end
    end
  end
end
