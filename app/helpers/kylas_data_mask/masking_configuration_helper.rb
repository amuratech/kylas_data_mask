# frozen_string_literal: true

module KylasDataMask
  module MaskingConfigurationHelper
    def cache_masking_configuration(entity_type, user_id, api_key)
      Rails.cache.fetch("user_#{user_id}_#{entity_type}_mask_configuration", expires_in: 30.minutes) do
        response = KylasDataMask::MaskedFields.new(api_key: api_key, entity_type: entity_type).fetch
        response[:data] if response[:success]
      end
    end

    def clear_cache_masking_configuration(entity_type, user_id)
      Rails.cache.delete("user_#{user_id}_#{entity_type}_mask_configuration")
    end
  end
end
