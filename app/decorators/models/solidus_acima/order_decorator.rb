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

    def json_acima_customer
      acima_customer.to_json
    end

    def acima_customer
      address = bill_address
      {
        firstName: address.name.split(' ').first,
        middleName: address.name.split(' ')[1..-2].join(' '),
        lastName: address.name.split(' ').last,
        phone: address.phone,
        email: email,
        address: {
          street1: address.address1,
          street2: address.address2,
          city: address.city,
          state: address.state.abbr,
          zipCode: address.zipcode,
        }
      }
    end

    private

    def cents(float)
      (float * 100).to_i
    end

    Spree::Order.prepend(self)
  end
end
