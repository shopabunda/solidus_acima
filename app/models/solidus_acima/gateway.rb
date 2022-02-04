# frozen_string_literal: true

module SolidusAcima
  class Gateway
    include HTTParty

    def initialize(*args); end

    def authorize(_amount, payment_source, _gateway_options); end

    def capture(amount, order_id, options)
      # send api call to capture payment
      url = "#{options[:iframe_url]}merchants/#{options[:merchant_id]}/leases/#{options[:lease_id]}/finalize"
      headers = { "API-Token": options[:api_key] }
      body = { checkout_token: options[:checkout_token], transaction: options[:transaction] }.to_json
      response = HTTParty.post(url, headers: headers, body: body)

      if response.success?
        # capture_id = response['Capture-ID']
        # payment_source = Spree::KlarnaCreditPayment.find_by(order_id: order_id)
        # update_payment_source!(payment_source, order_id, capture_id: capture_id)

        # update_payment_source!(payment_source, order_id, capture_id: capture_id)

        ActiveMerchant::Billing::Response.new(
          true,
          "Captured order with Acima id: '#{order_id}'",
          response.body || {},
          authorization: order_id
        )
      else
        ActiveMerchant::Billing::Response.new(
          false,
          readable_error(response),
          response.body || {},
          error_code: response.error_code
        )
      end
    end

    def void(*args); end

    def purchase(*args); end

    def generate_signature(to_sign)
      digest = OpenSSL::Digest.new("sha256")
      hmac = OpenSSL::HMAC.digest(digest, secret, to_sign)
      Base64.strict_encode64(hmac)
    end
  end
end
