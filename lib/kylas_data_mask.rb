# frozen_string_literal: true

require 'kylas_data_mask/version'
require 'kylas_data_mask/engine'
require 'kylas_data_mask/url_builder'

module KylasDataMask
  class ContextConfigurationError < StandardError; end

  class Context
    attr_accessor :api_url, :api_version, :marketplace_app_host, :marketplace_app_id, :user_model_name

    class << self
      attr_accessor :config
    end

    def self.setup
      self.config ||= Context.new
      yield(config)
      config.validate!
    end

    def validate!
      raise KylasDataMask::ContextConfigurationError, 'API URL is missing in the configuration' if api_url.nil?
      raise KylasDataMask::ContextConfigurationError, 'API Version is missing in the configuration' if api_version.nil?
      raise KylasDataMask::ContextConfigurationError, 'Marketplace app host is missing in the configuration' if marketplace_app_host.nil?
      raise KylasDataMask::ContextConfigurationError, 'Marketplace app id is missing in the configuration' if marketplace_app_id.nil?
      raise KylasDataMask::ContextConfigurationError, 'User model name is missing in the configuration' if user_model_name.nil?
    end
  end
end
