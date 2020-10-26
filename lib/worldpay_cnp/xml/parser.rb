module WorldpayCnp
  module XML
    module Parser
      def call(xml)
        hash_with(root(xml))
      end

      private

      def root(xml)
        raise NotImplementedError
      end

      def value_with!(element)
        raise NotImplementedError
      end

      def hash_with(*nodes)
        nodes.each_with_object({}) do |node, hash|
          inject_or_merge!(hash, node.name, value_with!(node))
        end
      end

      def inject_or_merge!(hash, key, value)
        if hash.key?(key)
          cv = hash[key]
          value = cv.is_a?(Array) ? cv.push(value) : [cv, value]
        end
        hash[key] = value
      end
    end
  end
end
