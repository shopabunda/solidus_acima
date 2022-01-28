# frozen_string_literal: true

module SolidusAcima
  module CheckoutHelper
    def order_for_acima_transaction(order)
      {
        id: order.number,
        discounts: order.adjustment_total,
        shipping: order.shipment_total,
        salesTax: order.additional_tax_total,
        lineItems: order.line_items.map do |line_item|
          {
            productId: line_item.sku,
            productName: line_item.name,
            unitPrice: line_item.price,
            quantity: line_item.quantity
          }
        end
      }.to_json
    end
  end
end
