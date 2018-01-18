require 'spec_helper'

RSpec.describe Liefery::Api::Shipment do

  describe '.create_shipment_quote' do
    it 'requests the correct resource' do
      client = Liefery::Client.new(api_key: 'api-key')
      post_data = create_shipment_quote_details.to_json
      request = stub_post('/shipments/quote').
        with(
          body: post_data,
        ).to_return(
          body: fixture('create_shipment_quote_response.json'),
          headers: { content_type: 'application/json; charset=utf-8'},
        )

      client.create_shipment_quote(create_shipment_quote_details)

      expect(request).to have_been_made
    end

    it 'returns a Liefery shipment quote' do
      client = Liefery::Client.new(api_key: 'api-key')
      stub_post('/shipments/quote').
        to_return(
          body: fixture('create_shipment_quote_response.json'),
          headers: { content_type: 'application/json; charset=utf-8'}
        )

      shipment_quote = client.
        create_shipment_quote(create_shipment_quote_details)

      expect(shipment_quote.gross_price.cents).to eq '832'
      expect(shipment_quote.gross_price.currency).to eq 'EUR'
    end

    it 'sends the correct post body' do
      client = Liefery::Client.new(api_key: 'api-key')

      request = stub_post('/shipments/quote').with(
      body: JSON.parse(File.read(fixture('create_shipment_quote.json'))).to_json,
      ).to_return(
      body: fixture('shipment.json'),
      headers: { content_type: 'application/json; charset=utf-8' },
      )

      client.create_shipment_quote(create_shipment_quote_details)

      expect(request).to have_been_made
    end

    def create_shipment_quote_details
      {
        'shipment' => {
          'packages' => [
            {
              'size' => 'M',
              'weight' => 3,
              'length' => 30,
              'width' => 25,
              'height' => 10
            }
          ],
          'pick_up_address' => {
            'street' => 'Sanderstr. 28',
            'zip' => '12047',
            'city' => 'Berlin'
          },
          'drop_off_address' => {
            'street' => 'Brunnenstr. 10',
            'zip' => '10119',
            'city' => 'Berlin'
          }
        }
      }
    end
  end
end
