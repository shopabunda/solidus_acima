# frozen_string_literal: true

FactoryBot.define do
  factory :acima_payment_source, class: SolidusAcima::PaymentSource do
    merchant_id    { 'loca-3b73538c-b7ff-4b9b-b78e-f6906523ae16' }
    iframe_url     { 'https://ecom.sandbox.acimacredit.com' }
    api_key        { 'api_key' }
    lease_id       { 'leas-f22d4693-b66e-4104-b4d8-ff20e4be1394' }
    lease_number   { '12345' }
    checkout_token { 'ecom-checkout-53511533-0f75-4942-82b9-5a6989871a03' }
    payment_method
  end
end
