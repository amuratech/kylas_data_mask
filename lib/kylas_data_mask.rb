# frozen_string_literal: true

require 'net/http'
require 'active_support/all'
require_relative 'kylas_data_mask/constants'
require_relative 'kylas_data_mask/version'
require_relative 'kylas_data_mask/configuration'
require_relative 'kylas_data_mask/fetch_masked_fields'
require_relative 'kylas_data_mask/fetch_unmasked_data'
require_relative 'kylas_data_mask/fetch_system_admin_profile'

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

  def self.field_is_masked_or_not?(masked_fields_list:, user_profile_id:, field:)
    if user_profile_id == SYSTEM_ADMIN_PROFILE_ID
      false
    else
      masked_field_detail = masked_fields_list.find { |masked_field| masked_field['name'] == field }

      return false if masked_field_detail.blank?

      masked_profiles = masked_field_detail['maskConfiguration']['profileIds']

      return (masked_profiles.to_a.include?(user_profile_id) || masked_profiles.size.zero?)
    end
  end

  def self.format_field_value(value:, masked:)
    masked ? "****#{value[-3..-1]}" : value
  end
end
