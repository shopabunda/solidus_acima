# frozen_string_literal: true

module SolidusAcima
  class PaymentMethod < SolidusSupport.payment_method_parent_class
    preference :merchant_id, :string
    preference :client_id, :string
    preference :client_secret, :string

    def gateway_class
      ::SolidusAcima::Gateway
    end

    def payment_source_class
      ::SolidusAcima::PaymentSource
    end

    def partial_name
      "acima"
    end

    def preferred_iframe_url
      preferred_test_mode ? 'https://ecom.sandbox.acimacredit.com' : 'https://ecom.acimacredit.com'
    end
  end
end
