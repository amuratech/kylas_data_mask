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

  def self.field_is_masked_or_not?(masked_fields_list:, user_profile_id:, field:, system_admin_profile_id: nil)
    if system_admin_profile_id == user_profile_id
      # Need to update this once requirement is clear
      false
    else
      masked_field_detail = masked_fields_list.find { |masked_field| masked_field['name'] == field }

      return false if masked_field_detail.blank?

      masked_profiles = masked_field_detail['maskConfiguration']['profileIds']
      if masked_profiles.size > 0
        if masked_profiles.include?(user_profile_id)
          true
        else
          false
        end
      elsif masked_profiles.size == 0
        true
      end
    end
  end

  def self.masked_or_unmasked_field_value(field_value:, is_field_masked:)
    if is_field_masked
      "****#{field_value[-3..-1]}"
    else
      field_value
    end
  end
end
