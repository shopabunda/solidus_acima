require 'spec_helper'
require 'httparty'

RSpec.describe SolidusAcima::Gateway, type: :model do
  let(:gateway) do
    described_class.new({
      merchant_id: 'merchant_id',
      iframe_url: 'https://www.iframe.url/',
      api_key: 'api_key'
    })
  end
  let(:payment_source) { create(:acima_payment_source) }
  let(:payment) { create(:acima_payment) }

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

  describe '#capture' do
    subject(:capture_response) { gateway.capture(nil, payment_source.checkout_token, { originator: payment }) }

    let(:api_response) { double(HTTParty) }

    before do
      payment.order.update(state: 'complete')
      payment.update(state: 'pending')
      allow(HTTParty).to receive(:post).and_return(api_response)
      allow(api_response).to receive(:body).and_return('')
    end

    context 'when successful' do
      before { allow(api_response).to receive(:success?).and_return(true) }

      it 'creates a billing response' do
        expect(capture_response.class).to eq(ActiveMerchant::Billing::Response)
      end

      it 'the response returns true on #success?' do
        expect(capture_response.success?).to eq(true)
      end
    end

    context 'when failed' do
      before do
        allow(api_response).to receive(:success?).and_return(false)
        allow(api_response).to receive(:code).and_return(415)
      end

      it 'creates a failed billing response' do
        expect(capture_response.class).to eq(ActiveMerchant::Billing::Response)
      end

      it 'the response returns false on #success?' do
        expect(capture_response.success?).to eq(false)
      end
    end
  end
end
