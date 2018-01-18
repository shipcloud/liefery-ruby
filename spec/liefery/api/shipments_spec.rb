require 'spec_helper'

RSpec.describe Liefery::Api::Shipment do
  describe '.shipment' do
    it 'requests the correct resource' do
      client = Liefery::Client.new(api_key: 'api-key')
      request = stub_get('/shipments/FYGIT').
        to_return(
          body: fixture('shipment.json'),
          headers: { content_type: 'application/json; charset=utf-8'}
        )

      client.shipment('FYGIT')

      expect(request).to have_been_made
    end

    it 'returns a Liefery shipment' do
      client = Liefery::Client.new(api_key: 'api-key')
      stub_get('/shipments/FYGIT').
        to_return(
          body: fixture('shipment.json'),
          headers: { content_type: 'application/json; charset=utf-8' }
        )

      shipment = client.shipment('FYGIT')

      expect(shipment.id).to eq 'FYGIT'
      expect(shipment.incoming_api_id).to eq 'external-id'
      expect(shipment.gross_price.cents).to eq '832'
    end
  end

  describe '.create_shipment' do
    it 'requests the correct resource' do
      client = Liefery::Client.new(api_key: 'api-key')
      post_data = create_shipment_details.to_json
      request = stub_post('/shipments').
        with(
          body: post_data,
        ).to_return(
          body: fixture('shipment.json'),
          headers: { content_type: 'application/json; charset=utf-8'},
        )

      client.create_shipment(create_shipment_details)

      expect(request).to have_been_made
    end

    it 'sends the correct post body' do
      client = Liefery::Client.new(api_key: 'api-key')

      request = stub_post('/shipments').with(
          body: JSON.parse(File.read(fixture('create_shipment.json'))).to_json,
        ).to_return(
          body: fixture('shipment.json'),
          headers: { content_type: 'application/json; charset=utf-8' },
        )

      client.create_shipment(create_shipment_details)

      expect(request).to have_been_made
    end
  end

  def create_shipment_details
    {
      'shipment' => {
        'incoming_api_id' => 'external-id',
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
          'city' => 'Berlin',
          'zip' => '12047',
          'street' => 'Sanderstr. 28',
          'contact_name' => 'Hans Mustermann',
          'email' => 'hans@example.com',
          'phone' => '012 345 678',
          'company' => 'Bitcrowd',
          'comment' => 'Aufgang II'
        },
        'drop_off_address' => {
          'city' => 'Berlin',
          'zip' => '10119',
          'street' => 'Brunnenstr. 10',
          'contact_name' => 'Erika Mustermann',
          'email' => 'erika@example.com',
          'phone' => '012 345 678',
          'company' => 'Minglabs',
          'comment' => 'Baustelle vorm Eingang'
        },
        'description' => 'handle with care',
        'scheduled_pick_up_time_type' => 'asap',
        'scheduled_drop_off_time_type' => 'time_window',
        'scheduled_drop_off_time_from' => '2014-11-28T16:44:35.458+01:00',
        'scheduled_drop_off_time_until' => '2014-11-28T17:44:35.458+01:00'
      }
    }
  end
end
