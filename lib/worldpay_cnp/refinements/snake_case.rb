module WorldpayCnp
  module Refinements
    module SnakeCase
      refine Hash do

        def to_snake_case
          _to_snake_case(self)
        end

        private

        def _to_snake_case(data)
          case data
          when Array
            data.map { |value| _to_snake_case(value) }
          when Hash
            data.map { |key, value| [underscore_key(key), _to_snake_case(value)] }.to_h
          else
            data
          end
        end

        def underscore_key(key)
          case key
          when Symbol
            underscore(key.to_s).to_sym
          when String
            underscore(key).to_sym
          else
            key
          end
        end

        def underscore(string)
          @__memoize_underscore ||= {}
          return @__memoize_underscore[string] if @__memoize_underscore[string]
          @__memoize_underscore[string] =
            string.gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
                  .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                  .downcase
          @__memoize_underscore[string]
        end

      end
    end
  end
end
