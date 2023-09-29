# frozen_string_literal: true

module KylasDataMask
  class ConfigurationError < StandardError; end

  class Configuration
    attr_accessor :api_url

    def validate!
      raise ConfigurationError, 'API URL is missing in the configuration' if api_url.nil?
    end
  end
end
