# frozen_string_literal: true

module SolidusAcima
  module CheckoutHelper
    def cents(float)
      (float * 100).to_i
    end

    def order_for_acima_transaction(order)
      {
        id: order.number,
        discounts: cents(order.adjustment_total),
        shipping: cents(order.shipment_total),
        salesTax: cents(order.additional_tax_total),
        lineItems: order.line_items.map do |line_item|
          {
            productId: line_item.sku,
            productName: line_item.name,
            unitPrice: cents(line_item.price),
            quantity: line_item.quantity
          }
        end
      }.to_json
    end
  end
end
