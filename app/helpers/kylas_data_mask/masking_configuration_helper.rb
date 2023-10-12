# frozen_string_literal: true

module KylasDataMask
  module MaskingConfigurationHelper
    def cache_masking_configuration(entity_type)
      Rails.cache.fetch("user_#{current_user.id}_#{entity_type}_mask_configuration", expires_in: 30.minutes) do
        response = KylasDataMask::MaskedFields.new(api_key: current_tenant.kylas_api_key, entity_type: entity_type).fetch
        response[:data] if response[:success]
      end
    end

    def clear_cache_masking_configuration(entity_type)
      Rails.cache.delete("user_#{current_user.id}_#{entity_type}_mask_configuration")
    end
  end
end
