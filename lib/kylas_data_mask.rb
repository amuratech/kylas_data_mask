# frozen_string_literal: true

require 'net/http'
require 'active_support/all'
require_relative 'kylas_data_mask/constants'
require_relative 'kylas_data_mask/version'
require_relative 'kylas_data_mask/configuration'
require_relative 'kylas_data_mask/fetch_masked_fields'
require_relative 'kylas_data_mask/fetch_unmasked_data'

module KylasDataMask
  class Error < StandardError; end

  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield(config)
    config.validate!
  end
end
