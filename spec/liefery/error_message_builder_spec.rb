require 'spec_helper'

RSpec.describe Liefery::ErrorMessageBuilder do
  it 'builds an error message from the given hash' do
    error_hash = {
      'errors' => {
        'shipment' => {
          'packages.package_size_id' => [
            "Packages package size can't be blank",
          ],
          'state' => ['Status -> Price can not be calculated'],
        }
      }
    }

    expect(Liefery::ErrorMessageBuilder.new(error_hash).build).to eq(
      'Packages package size can\'t be blank, ' \
        'Status -> Price can not be calculated'
    )
  end

  it 'builds an error message from the given hash' do
    error_hash =  {
      'errors' => {
        'shipment' => {
          'drop_off_address.geo_location' => [
            'Geo Koordinaten could not be found: Rentzelstraße 80, 20146 Hamburg'
          ],
          'state' => ['Status -> missing mandatory parameters']
        }
      }
    }

    expect(Liefery::ErrorMessageBuilder.new(error_hash).build).to eq(
      'Geo Koordinaten could not be found: Rentzelstraße 80, 20146 Hamburg, ' \
        'Status -> missing mandatory parameters'
    )
  end
end
