require 'liefery/error_message_builder'

module Liefery
  # Custom error class for rescuing from all time:matters errors
  class Error < StandardError
    attr_reader :response
    # Returns the appropriate Liefery::Error sublcass based
    # on status and response message
    #
    # @param [Hash] response HTTP response
    # @return [Liefery::Error]
    def self.from_response(response)
      status  = response[:status].to_i

      if klass = error_class_from_status(status)
        klass.new(response)
      end
    end

    def initialize(response = nil)
      @response = response
      super(build_error_message)
    end

    def errors
      if response_hash
        response_hash.fetch('errors', {})
      end
    end

    def response_hash
      if data && data.respond_to?(:to_hash)
        data.to_hash
      end
    end

    def http_status
      response.status
    end

    private

    def self.error_class_from_status(status)
      case status
      when 400      then Liefery::BadRequest
      when 401      then Liefery::Unauthorized
      when 403      then Liefery::Forbidden
      when 404      then Liefery::NotFound
      when 406      then Liefery::NotAcceptable
      when 409      then Liefery::Conflict
      when 415      then Liefery::UnsupportedMediaType
      when 422      then Liefery::UnprocessableEntity
      when 400..499 then Liefery::ClientError
      when 500      then Liefery::InternalServerError
      when 501      then Liefery::NotImplemented
      when 502      then Liefery::BadGateway
      when 503      then Liefery::ServiceUnavailable
      when 500..599 then Liefery::ServerError
      end
    end

    def data
      @data ||=
        if (body = @response[:body]) && !body.empty?
          body
        else
          nil
        end
    end


    def build_error_message
      return nil if @response.nil? || response_hash.nil?

      ErrorMessageBuilder.new(response_hash).build
    end
  end

  # Raised on errors in the 400-499 range
  class ClientError < Error; end

  # Raised when time:matters returns a 400 HTTP status code
  class BadRequest < ClientError; end

  # Raised when time:matters returns a 401 HTTP status code
  class Unauthorized < ClientError; end

  # Raised when time:matters returns a 403 HTTP status code
  class Forbidden < ClientError; end

  # Raised when time:matters returns a 403 HTTP status code
  # and body matches 'rate limit exceeded'
  class TooManyRequests < Forbidden; end

  # Raised when time:matters returns a 403 HTTP status code
  # and body matches 'login attempts exceeded'
  class TooManyLoginAttempts < Forbidden; end

  # Raised when time:matters returns a 404 HTTP status code
  class NotFound < ClientError; end

  # Raised when time:matters returns a 406 HTTP status code
  class NotAcceptable < ClientError; end

  # Raised when time:matters returns a 409 HTTP status code
  class Conflict < ClientError; end

  # Raised when time:matters returns a 414 HTTP status code
  class UnsupportedMediaType < ClientError; end

  # Raised when time:matters returns a 422 HTTP status code
  class UnprocessableEntity < ClientError; end

  # Raised on errors in the 500-599 range
  class ServerError < Error; end

  # Raised when time:matters returns a 500 HTTP status code
  class InternalServerError < ServerError; end

  # Raised when time:matters returns a 501 HTTP status code
  class NotImplemented < ServerError; end

  # Raised when time:matters returns a 502 HTTP status code
  class BadGateway < ServerError; end

  # Raised when time:matters returns a 503 HTTP status code
  class ServiceUnavailable < ServerError; end
end
