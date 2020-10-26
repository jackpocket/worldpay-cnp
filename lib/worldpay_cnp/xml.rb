require "worldpay_cnp/xml/parser"
require "worldpay_cnp/xml/serializer"
require "worldpay_cnp/xml/nokogiri"

module WorldpayCnp
  module XML
    class << self
      def parse(xml)
        Nokogiri::Parser.new.call(xml)
      end

      def serialize(hash)
        Nokogiri::Serializer.new.call(hash)
      end
    end
  end
end
