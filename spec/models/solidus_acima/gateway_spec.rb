require 'spec_helper'

RSpec.describe SolidusAcima::Gateway, type: :model do
  let(:gateway)        { described_class.new({}) }
  let(:payment_source) { create(:acima_payment_source) }

  describe '#initialize' do
    it 'initializes' do
      expect(gateway).to be_an_instance_of(described_class)
    end
  end

  describe '#authorize' do
    subject(:authorize_response) { gateway.authorize(nil, payment_source, {}) }

    it 'successfully returns a response' do
      expect(authorize_response).to be_an_instance_of(ActiveMerchant::Billing::Response)
    end
  end
end
