# frozen_string_literal: true

require 'httparty'

module SolidusAcima
  class Gateway
    attr_reader :merchant_id, :iframe_url, :api_key, :api_url, :acima_bearer_token

    def initialize(options)
      @merchant_id = options[:merchant_id]
      @iframe_url = options[:iframe_url]
      @api_key = options[:api_key]
      sandbox = options[:iframe_url].include?('sandbox') ? '-sandbox' : ''
      @api_url = "https://api#{sandbox}.acimacredit.com/api"
      @acima_bearer_token = generate_bearer_token
    end

    def authorize(_amount, payment_source, _gateway_options)
      ActiveMerchant::Billing::Response.new(
        true,
        'Transaction approved',
        payment_source.attributes,
        authorization: payment_source.checkout_token
      )
    end

    def capture(_amount, checkout_token, options)
      # send api call to Acima to capture payment
      source = options[:originator].source
      order = options[:originator].order
      transaction = order.acima_transaction

      url = "#{iframe_url}/merchants/#{merchant_id}/leases/#{source.lease_id}/finalize"
      headers = { 'API-Token': api_key }
      body = { checkout_token: checkout_token, transaction: transaction }.to_json
      response = HTTParty.post(url, headers: headers, body: body)

      if response.success?
        ActiveMerchant::Billing::Response.new(
          true,
          'Transaction captured',
          response.body.blank? ? {} : JSON.parse(response.body),
          authorization: checkout_token
        )
      else
        ActiveMerchant::Billing::Response.new(
          false,
          'Transaction error',
          response.body.blank? ? {} : JSON.parse(response.body),
          error_code: response.code
        )
      end
    end

    def credit(_amount, checkout_token, options)
      payment_source = options[:originator].source

      url = "#{api_url}/contracts/#{payment_source.lease_id}/termination"
      headers = { 'Authorization': "Bearer #{acima_bearer_token}" }
      response = HTTParty.post(url, headers: headers)

      raise 'Acima Server Response Error: Did not get correct response code' unless response.success?

      payment_source.update(status: 'REFUNDED')
      ActiveMerchant::Billing::Response.new(
        true,
        'Transaction refunded',
        response.body.blank? ? {} : JSON.parse(response.body),
        authorization: checkout_token
      )
    end

    def purchase(amount, checkout_token, options)
      capture(amount, checkout_token, options)
    end

    def void(checkout_token, options)
      payment_source = options[:originator].source

      url = "#{api_url}/contracts/#{payment_source.lease_id}/termination"
      headers = { 'Authorization': "Bearer #{acima_bearer_token}", 'Accept': 'application/vnd.acima-v2+json' }
      response = HTTParty.post(url, headers: headers)

      raise 'Acima Server Response Error: Did not get correct response code' unless response.success?

      payment_source.update(status: 'VOIDED')
      ActiveMerchant::Billing::Response.new(
        true,
        'Transaction voided',
        response.body.blank? ? {} : JSON.parse(response.body),
        authorization: checkout_token
      )
    end

    private

    def generate_bearer_token
      url = "#{api_url}/oauth/token"
      headers = { 'Content-Type': 'application/json' }
      body = {
        client_id: merchant_id,
        client_secret: api_key,
        audience: 'https://aperture.acimacredit.com',
        grant_type: 'client_credentials'
      }.to_json

      response = HTTParty.post(url, headers: headers, body: body)

      raise "Acima Server Response Error: #{response}" unless response.success?

      response['access_token']
    end
  end
end
