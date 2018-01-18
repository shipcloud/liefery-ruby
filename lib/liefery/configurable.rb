module Liefery
  module Configurable
    attr_accessor :api_key, :api_version, :user_agent, :default_media_type,
                  :middleware, :production
    attr_writer :api_endpoint
    class << self

      # List of configurable keys for Liefery::Client
      def keys
        @keys ||= [
          :api_endpoint,
          :api_key,
          :api_version,
          :user_agent,
          :default_media_type,
          :middleware,
          :production
        ]
      end
    end

    # Set configuration options using a block
    def configure
      yield self
    end

    # Reset configuration options to default values
    def reset!
      Liefery::Configurable.keys.each do |key|
        send(:"#{key}=", Liefery::Default.options[key])
      end
      self
    end
    alias setup reset!

    def api_endpoint
      endpoint = @api_endpoint ||
       production && production_api_endpoint ||
       sandbox_api_endpoint
      File.join(endpoint, "")
    end

    def sandbox_api_endpoint
      Liefery::Default.sandbox_api_endpoint
    end

    def production_api_endpoint
      Liefery::Default.production_api_endpoint
    end

    private

    def options
      Hash[Liefery::Configurable.keys.map{|key| [key, send(:"#{key}")]}]
    end
  end
end
