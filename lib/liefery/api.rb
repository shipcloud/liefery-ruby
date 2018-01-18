require 'liefery/api/shipment'
require 'liefery/api/shipment_quote'

module Liefery
  module Api
    include Liefery::Api::Shipment
    include Liefery::Api::ShipmentQuote
  end
end
