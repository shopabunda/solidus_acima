# frozen_string_literal: true

module SolidusAcima
  class Gateway
    def initialize(*args); end

    def authorize(_amount, payment_source, _options)
      ActiveMerchant::Billing::Response.new(
        true,
        'Transaction approved',
        payment_source.attributes,
        authorization: payment_source.checkout_token
      )
    end

    def capture(*args); end

    def void(*args); end

    def purchase(*args); end

    def generate_signature(to_sign)
      digest = OpenSSL::Digest.new("sha256")
      hmac = OpenSSL::HMAC.digest(digest, secret, to_sign)
      Base64.strict_encode64(hmac)
    end
  end
end
