module WorldpayCnp
  class Error < StandardError
    InvalidFormatError = Class.new(self)
    XmlParseError = Class.new(self)

    # Raised on a 4xx HTTP status code
    ClientError = Class.new(self)

    # Raised on the HTTP status code 403
    Forbidden = Class.new(ClientError)

    # Raised on the HTTP status code 404
    NotFound = Class.new(ClientError)

    # Raised on the HTTP status code 405
    MethodNotAllowed = Class.new(ClientError)

    # Raised on the HTTP status code 417
    ExpectationFailed = Class.new(ClientError)

    # Raised on a 5xx HTTP status code
    ServerError = Class.new(self)

    # Raised on the HTTP status code 500
    InternalServerError = Class.new(ServerError)

    # Raised on the HTTP status code 502
    BadGateway = Class.new(ServerError)

    # Raised on the HTTP status code 503
    ServiceUnavailable = Class.new(ServerError)

    # Raised on the HTTP status code 504
    GatewayTimeout = Class.new(ServerError)

    ERRORS_BY_STATUS = {
      403 => Error::Forbidden,
      404 => Error::NotFound,
      405 => Error::MethodNotAllowed,
      417 => Error::ExpectationFailed,
      500 => Error::InternalServerError,
      502 => Error::BadGateway,
      503 => Error::ServiceUnavailable,
      504 => Error::GatewayTimeout,
    }

    class << self
      # Create a new error from an HTTP response body and status
      #
      # @param body [String]
      # @param status [Integer]
      # @return [WorldpayCnp::Error]
      def from_http_response(body, status)
        klass = ERRORS_BY_STATUS[status] || self
        klass.new("Service error (Status: #{status})", raw_response: body)
      end
    end

    # The raw HTTP response, if applicable
    #
    # @return [String]
    attr_reader :raw_response

    # The response code in the XML root element. The value of the
    # response attribute in the following example:
    #
    # <cnpOnlineResponse version="12.17" xmlns="http://www.vantivcnp.com/schema"
    #   response="1" message="Error validating xml..." />
    #
    # @return [String]
    attr_reader :response_code

    # Initializes a new Error object
    #
    # @param message [Exception, String]
    # @param code [String]
    # @param raw_http_response [String]
    # @return [WorldpayCnp::Error]
    def initialize(message, response_code: '', raw_response: '')
      @response_code = response_code
      @raw_response = raw_response
      super(message)
    end
  end
end
