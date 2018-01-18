require 'spec_helper'

RSpec.describe Liefery::Error do

  describe '#message' do
    it 'returns the error message from the response' do
      response = {
        status: 123,
        method: 'post',
        url: 'http://example.com/some_path',
        body: {
          'errors' => {
            'shipment' => {
              'packages.package_size_id' => [
                "Packages package size can't be blank"
              ],
              'state' => ['Status -> Price can not be calculated'],
            }
          }
        }
      }

      error = Liefery::Error.new(response)

      expect(error.message).to eq 'Packages package size can\'t be blank, ' \
        'Status -> Price can not be calculated'
    end
  end

  describe '.from_response' do
    it 'returns Liefery::BadRequest for status code 400' do
      expect(
        Liefery::Error.from_response({ status: 400 })
      ).to be_a Liefery::BadRequest
    end

    it 'returns Liefery::Unauthorized for status code 401' do
      expect(
        Liefery::Error.from_response({ status: 401 })
      ).to be_a Liefery::Unauthorized
    end

    it 'returns Liefery::Forbidden for status code 403' do
      expect(
        Liefery::Error.from_response({ status: 403 })
      ).to be_a Liefery::Forbidden
    end

    it 'returns Liefery::NotFound for status code 404' do
      expect(
        Liefery::Error.from_response({ status: 404 })
      ).to be_a Liefery::NotFound
    end

    it 'returns Liefery::NotAcceptable for status code 406' do
      expect(
        Liefery::Error.from_response({ status: 406 })
      ).to be_a Liefery::NotAcceptable
    end


    it 'returns Liefery::Conflict for status code 409' do
      expect(
        Liefery::Error.from_response({ status: 409 })
      ).to be_a Liefery::Conflict
    end


    it 'returns Liefery::UnsupportedMediaType for status code 415' do
      expect(
        Liefery::Error.from_response({ status: 415 })
      ).to be_a Liefery::UnsupportedMediaType
    end

    it 'returns Liefery::UnprocessableEntity for status code 422' do
      expect(
        Liefery::Error.from_response({ status: 422 })
      ).to be_a Liefery::UnprocessableEntity
    end

    it 'returns Liefery::ClientError for status code 499' do
      expect(
        Liefery::Error.from_response({ status: 499 })
      ).to be_a Liefery::ClientError
    end

    it 'returns Liefery::InternalServerError for status code 500' do
      expect(
        Liefery::Error.from_response({ status: 500 })
      ).to be_a Liefery::InternalServerError
    end

    it 'returns Liefery::NotImplemented for status code 501' do
      expect(
        Liefery::Error.from_response({ status: 501 })
      ).to be_a Liefery::NotImplemented
    end

    it 'returns Liefery::BadGateway for status code 502' do
      expect(
        Liefery::Error.from_response({ status: 502 })
      ).to be_a Liefery::BadGateway
    end

    it 'returns Liefery::ServiceUnavailable for status code 503' do
      expect(
        Liefery::Error.from_response({ status: 503 })
      ).to be_a Liefery::ServiceUnavailable
    end

    it 'returns Liefery::ServerError for status code 599' do
      expect(
        Liefery::Error.from_response({ status: 599 })
      ).to be_a Liefery::ServerError
    end
  end
end
