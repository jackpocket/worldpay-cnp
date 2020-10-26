module WorldpayCnp
  module Refinements
    module CamelCase
      refine Hash do

        def to_camel_case
          _to_camel_case(self)
        end

        private

        def _to_camel_case(data)
          case data
          when Array
            data.map { |value| _to_camel_case(value) }
          when Hash
            data.map { |key, value| [camel_case_key(key), _to_camel_case(value)] }.to_h
          else
            data
          end
        end

        def camel_case_key(key)
          case key
          when Symbol
            camel_case(key.to_s).to_sym
          when String
            camel_case(key).to_sym
          else
            key
          end
        end

        def camel_case(string)
          @acronyms ||= { 'au' => 'AU', 'iias' => 'IIAS' }
          @acronym_regex ||= /#{@acronyms.values.join("|")}/
          result = string.sub(/^[a-z\d]*/) { |match| @acronyms[match] || match }
          result.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{@acronyms[$2] || $2.capitalize}" }
        end

      end
    end
  end
end
