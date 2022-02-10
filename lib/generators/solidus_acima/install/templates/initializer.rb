# frozen_string_literal: true

SolidusAcima.configure do |config|
  config.acima_merchant_id = ENV.fetch('ACIMA_MERCHANT_ID', '')
  config.acima_iframe_url = ENV.fetch('ACIMA_IFRAME_URL', '')
  # config.acima_api_key = ENV.fetch('ACIMA_API_KEY', '') # when uncommented rails commands stop working
end
