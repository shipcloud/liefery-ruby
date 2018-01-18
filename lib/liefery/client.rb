require 'base64'
require 'rash'
require 'liefery/configurable'
require 'liefery/api'

module Liefery
  class Client
    include Liefery::Configurable
    include Liefery::Api

    attr_accessor :api_key

    def initialize(options = {})
      Liefery::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Liefery.instance_variable_get(:"@#{key}"))
      end
    end

    def get(url, options = {})
      request :get, url, options
    end

    def post(url, options = {})
      request :post, url, options
    end

    def put(url, options = {})
      request :put, url, options
    end

    def patch(url, options = {})
      request :patch, url, options
    end

    def delete(url, options = {})
      request :delete, url, options
    end

    def head(url, options = {})
      request :head, url, options
    end

    private

    def connection
      @connection ||= Faraday.new(api_endpoint, connection_options)
    end

    def request(method, path, params = {})
      path = "#{api_base_path}/#{path}"
      headers = params.delete(:headers) || {}
      if accept = params.delete(:accept)
        headers[:accept] = accept
      end

      headers['API-Key'] = "#{api_key}"

      response = connection.send(method.to_sym, path, params) {
        |request| request.headers.update(headers)
      }.env
      response.body
    end

    def connection_options
      @connection_options ||= {
        :builder => middleware,
        :headers => {
          :accept => default_media_type,
          :user_agent => user_agent,
        },
        :request => {
          :open_timeout => 10,
          :timeout => 30,
        },
      }
    end

    def api_base_path
      "/api/partner/#{api_version}"
    end
  end
end
