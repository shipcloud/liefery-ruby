module Liefery
  class ErrorMessageBuilder
    attr_reader :error_hash

    def initialize(error_hash)
      @error_hash = error_hash
    end

    def build
      flatten_recursively(error_hash).join(', ')
    end

    private

    def flatten_recursively(hash)
      messages = []
      hash.each do |_key, value|
        if value.is_a? Hash
          messages << flatten_recursively(value)
        elsif value.is_a? Array
          messages += value
        else
          messages << value
        end
      end
      messages
    end
  end
end
