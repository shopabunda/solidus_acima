require 'spec_helper'

RSpec.describe SolidusAcima::PaymentMethod, type: :model do
  describe '#gateway_class' do
    it 'has correct gateway class' do
      expect(described_class.new.gateway_class).to eq SolidusAcima::Gateway
    end
  end

  describe '#payment_source_class' do
    it 'has correct payment_source class' do
      expect(described_class.new.payment_source_class).to eq SolidusAcima::PaymentSource
    end
  end

  describe '#partial_name' do
    it 'has correct partial name' do
      expect(described_class.new.partial_name).to eq 'acima'
    end
  end
end
