# frozen_string_literal: true

module SolidusAcima
  class Gateway
    def initialize(*args); end

    def authorize(_amount, payment_source, _gateway_options); end

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
