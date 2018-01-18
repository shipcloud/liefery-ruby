module Liefery
  module Api
    module ShipmentQuote
      def create_shipment_quote(options)
        shipment_quote = post 'shipments/quote', options
        shipment_quote.quote if shipment_quote
      end
    end
  end
end
