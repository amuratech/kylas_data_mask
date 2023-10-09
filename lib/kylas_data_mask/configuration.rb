# frozen_string_literal: true

module KylasDataMask
  class ConfigurationError < StandardError; end

  class Configuration
    attr_accessor :api_url, :api_version, :marketplace_app_host, :marketplace_app_id, :user_model

    def validate!
      raise ConfigurationError, 'API URL is missing in the configuration' if api_url.nil?
      raise ConfigurationError, 'API Version is missing in the configuration' if api_version.nil?
      raise ConfigurationError, 'Marketplace app host is missing in the configuration' if marketplace_app_host.nil?
      raise ConfigurationErrorm 'Marketplace app id is missing in the configuration' if marketplace_app_id.nil?
      raise ConfigurationErrorm 'User model is missing in the configuration' if user_model.nil?
    end
  end
end
