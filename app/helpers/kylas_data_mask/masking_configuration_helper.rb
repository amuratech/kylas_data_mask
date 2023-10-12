# frozen_string_literal: true

module KylasDataMask
  module MaskingConfigurationHelper
    def cache_masking_configuration
      Rails.cache.fetch("user_#{current_user.id}_lead_mask_configuration", expires_in: 30.minutes) do
        response = KylasDataMask::MaskedFields.new(api_key: current_tenant.kylas_api_key, entity_type: 'lead').fetch
        response[:data] if response[:success]
      end
    end

    def clear_cache_masking_configuration
      Rails.cache.delete("user_#{current_user.id}_lead_mask_configuration")
    end
  end
end
