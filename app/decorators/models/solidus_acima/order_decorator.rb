# frozen_string_literal: true

module SolidusAcima
  module OrderDecorator
    def json_acima_transaction
      acima_transaction.to_json
    end

    def acima_transaction
      {
        id: number,
        discounts: cents(adjustment_total),
        shipping: cents(shipment_total),
        salesTax: cents(additional_tax_total),
        lineItems: line_items.map do |line_item|
          {
            productId: line_item.sku,
            productName: line_item.name,
            unitPrice: cents(line_item.price),
            quantity: line_item.quantity
          }
        end
      }
    end

    private

    def cents(float)
      (float * 100).to_i
    end

    Spree::Order.prepend(self)
  end
end
