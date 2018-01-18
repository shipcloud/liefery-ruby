require 'liefery/response/raise_error'
require 'liefery/version'
require 'faraday_middleware'

module Liefery

  # Default configuration options for {Client}
  module Default

    SANDBOX_API_ENDPOINT = 'https://staging.liefery.com'.freeze

    PRODUCTION_API_ENDPOINT = 'https://www.liefery.com'.freeze

    API_VERSION = 'v1'

    PRODUCTION = false

    USER_AGENT   = "Liefery Ruby Gem #{Liefery::VERSION}".freeze

    MEDIA_TYPE   = 'application/json'

    MIDDLEWARE = Faraday::RackBuilder.new do |builder|
      builder.request :json
      builder.use Liefery::Response::RaiseError
      builder.response :rashify
      builder.request :url_encoded
      builder.response :json, content_type: /\bjson$/

      builder.adapter Faraday.default_adapter
    end

    class << self
      def options
        Hash[Liefery::Configurable.keys.map { |key| [key, send(key)] }]
      end

      def api_endpoint
        ENV['LIEFERY_ENDPOINT']
      end

      def sandbox_api_endpoint
        SANDBOX_API_ENDPOINT
      end

      def production_api_endpoint
        PRODUCTION_API_ENDPOINT
      end

      def api_version
        API_VERSION
      end

      def production
        PRODUCTION
      end

      def api_key
        ENV['LIEFERY_API_KEY']
      end

      def default_media_type
        ENV['LIEFERY_CLIENT_DEFAULT_MEDIA_TYPE'] || MEDIA_TYPE
      end

      def middleware
        MIDDLEWARE
      end

      def user_agent
        ENV['LIEFERY_USER_AGENT'] || USER_AGENT
      end
    end
  end
end
