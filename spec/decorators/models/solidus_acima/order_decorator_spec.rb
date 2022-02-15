require 'spec_helper'

RSpec.describe SolidusAcima::OrderDecorator do
  let(:order) { create(:order_with_line_items) }

  describe '#acima_transaction' do
    it 'returns a hash with line items and price' do
      line_item_price = order.acima_transaction[:lineItems].first[:unitPrice]
      expect(line_item_price).to eq((order.line_items.first.price * 100).to_i)
    end
  end

  describe '#json_acima_transaction' do
    it 'returns a json version of the #acima_transaction' do
      expect(order.json_acima_transaction).to eq(order.acima_transaction.to_json)
    end
  end
end
