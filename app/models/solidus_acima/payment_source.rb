# frozen_string_literal: true

require_dependency 'solidus_acima'

module SolidusAcima
  class PaymentSource < SolidusSupport.payment_source_parent_class
    def can_credit?(payment)
      payment.payment_method.gateway.acima_payment_captured?(payment.source.lease_id)
    end
  end
end
