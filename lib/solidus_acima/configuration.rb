# frozen_string_literal: true

module SolidusAcima
  class Configuration
    attr_accessor :acima_merchant_id, :acima_iframe_url, :acima_client_id, :acima_client_secret
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    alias config configuration

    def configure
      yield configuration
    end
  end
end
