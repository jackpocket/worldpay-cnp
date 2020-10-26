module WorldpayCnp
  class Response
    extend Forwardable

    attr_reader :status_code, :raw_response

    delegate [:dig, :to_h, :to_hash] => :@data

    def initialize(data, status_code, raw_response)
      @data = data || {}
      @status_code = status_code.to_i
      @raw_response = raw_response
    end
  end
end
