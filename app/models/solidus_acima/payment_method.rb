# frozen_string_literal: true

module SolidusAcima
  class PaymentMethod < SolidusSupport.payment_method_parent_class
    preference :merchant_id, :string
    preference :iframe_url, :string

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
