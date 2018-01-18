require 'faraday'
require 'liefery/error'

module Liefery
  # Faraday response middleware
  module Response

    # This class raises an Liefery-flavored exception based
    # HTTP status codes returned by the API
    class RaiseError < Faraday::Response::Middleware

      private

      def on_complete(response)
        if error = Liefery::Error.from_response(response)
          raise error
        end
      end
    end
  end
end
