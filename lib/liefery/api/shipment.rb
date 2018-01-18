module Liefery
  module Api
    module Shipment
      def shipment(id, options = {})
        shipment = get "shipments/#{id}"
        shipment.shipment if shipment
      end

      def create_shipment(options)
        shipment = post 'shipments', options
        shipment.shipment if shipment
      end
    end
  end
end
