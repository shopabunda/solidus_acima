require 'spec_helper'

RSpec.describe SolidusAcima::PaymentSource, type: :model do
  let(:column_list) {
    [
      'id',
      'merchant_id',
      'payment_method_id',
      'lease_id',
      'lease_number',
      'checkout_token',
      'client_id',
      'client_secret',
      'created_at',
      'updated_at'
    ].sort
  }

  describe 'Check Model Integrity' do
    it 'has correct table name' do
      expect(described_class.table_name).to eq 'solidus_acima_payment_sources'
    end

    it 'has correct attributes' do
      expect(described_class.new.attributes.keys.sort).to eq(column_list)
    end
  end

  describe '#can_credit?' do
    let(:gateway)        { SolidusAcima::Gateway.new({ test_mode: true }) }
    let(:payment_source) { create(:acima_payment_source) }
    let(:payment)        { create(:acima_payment) }

    it 'calls Gateway#acima_payment_captured?' do
      # rubocop:disable RSpec/MessageChain
      expect(payment).to receive_message_chain(:payment_method, :gateway, :acima_payment_captured?)
      # rubocop:enable RSpec/MessageChain
      described_class.new.can_credit?(payment)
    end
  end
end
