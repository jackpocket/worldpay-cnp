module WorldpayCnp
  module XML
    module Serializer
      def call(hash)
        raise NotImplementedError
      end

      private

      def attributes_or_elements!(parent, key, value)
        raise NotImplementedError
      end

      def insert_text!(element, text)
        raise NotImplementedError
      end

      def add_xml_elements!(parent, obj)
        case obj
        when Hash
          obj.each { |key, value| attributes_or_elements!(parent, key, value) }
        when Array
          obj.each { |value| add_xml_elements!(parent, value) }
        else
          insert_text!(parent, obj)
        end
        parent
      end

      def text_with(obj)
        obj.to_s
      end

      def attribute?(key)
        key.to_s.start_with?("@")
      end

      def attribute_name(key)
        key.to_s.sub(/^@/, "")
      end
    end
  end
end
