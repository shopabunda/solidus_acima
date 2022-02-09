# frozen_string_literal: true

module SolidusAcima
  class PaymentMethod < SolidusSupport.payment_method_parent_class
    preference :merchant_id, :string
    preference :iframe_url, :string
    preference :api_key, :string

    validates :preferred_iframe_url,
      inclusion: { in: %w[https://ecom.sandbox.acimacredit.com https://ecom.acimacredit.com] },
      allow_blank: true

    def gateway_class
      ::SolidusAcima::Gateway
    end

    def payment_source_class
      ::SolidusAcima::PaymentSource
    end

    def partial_name
      "acima"
    end
  end
end
