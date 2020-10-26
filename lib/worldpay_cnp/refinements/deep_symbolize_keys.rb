module WorldpayCnp
  module Refinements
    module DeepSymbolizeKeys
      refine Hash do

        def deep_symbolize_keys
          _deep_transform_keys_in_object(self, &:to_sym)
        end

        private

        def _deep_transform_keys_in_object(object, &block)
          case object
          when Hash
            object.each_with_object({}) do |(key, value), result|
              result[yield(key)] = _deep_transform_keys_in_object(value, &block)
            end
          when Array
            object.map { |value| _deep_transform_keys_in_object(value, &block) }
          else
            object
          end
        end

      end
    end
  end
end
