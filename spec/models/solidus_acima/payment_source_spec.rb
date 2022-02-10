require 'spec_helper'

RSpec.describe SolidusAcima::PaymentSource, type: :model do
  let(:column_list) {
    [
      'id',
      'merchant_id',
      'iframe_url',
      'api_key',
      'payment_method_id',
      'created_at',
      'updated_at',
      'lease_id',
      'lease_number',
      'checkout_token'
    ]
  }

  describe 'Check Model Integrity' do
    it 'has correct table name' do
      expect(described_class.table_name).to eq 'solidus_acima_payment_sources'
    end

    it 'has correct attributes' do
      expect(described_class.new.attributes.keys).to eq column_list
    end
  end
end
