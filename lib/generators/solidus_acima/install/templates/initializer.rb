# frozen_string_literal: true

SolidusAcima.configure do |config|
  config.acima_merchant_id = ENV.fetch('ACIMA_MERCHANT_ID', '')
  config.acima_client_id = ENV.fetch('ACIMA_CLIENT_ID', '')
  config.acima_client_secret = ENV.fetch('ACIMA_CLIENT_SECRET', '')
end
