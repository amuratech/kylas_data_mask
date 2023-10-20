# frozen_string_literal: true

module KylasDataMask
  module MaskingConfiguration
    def format_value_based_on_masking(entity_type, user, field_names, value, masking_type)
      field_is_masked?(entity_type, user, field_names) ? masking_based_on_type(value, masking_type) : value
    end

    def field_is_masked?(entity_type, user, field_names)
      profile_id = user.kylas_profile_id

      masked_fields_list = cache_masking_configuration(entity_type, user.id, user.tenant.kylas_api_key)

      return false if masked_fields_list.blank?

      masked_fields_details = masked_fields_list.select { |masked_field| field_names.include?(masked_field['name']) }

      return false if masked_fields_details.blank?

      masked_fields_details.any? do |masked_detail|
        masked_profiles = masked_detail['maskConfiguration']['profileIds']
        masked_profiles.to_a.include?(profile_id) || masked_profiles.size.zero?
      end
    end

    def masking_based_on_type(value, masking_type)
      case masking_type
      when KylasDataMask::PHONE_MASKING
        if value.start_with?('+')
          parsed_number = Phonelib.parse(value)
          country_code = parsed_number.country_code
          number_without_country_code = parsed_number.national(false).to_s[1..-1]
          "+#{country_code}****#{number_without_country_code.to_s[-3..]}"
        else
          "****#{value[-3..]}"
        end
      when KylasDataMask::NAME_MASKING
        if value.start_with?('+')
          parsed_number = Phonelib.parse(value)
          country_code = parsed_number.country_code
          number_without_country_code = parsed_number.national(false).to_s[1..-1]
          "+#{country_code}MaskedValue#{number_without_country_code.to_s[-3..]}"
        else
          "MaskedValue#{value[-3..]}"
        end
      end
    rescue StandardError => e
      Rails.logger.error "KylasDataMask -> masking_based_on_type -> Error Message: #{e.message}"

      "****#{value[-3..]}"
    end

    def cache_masking_configuration(entity_type, user_id, api_key)
      Rails.cache.fetch("user_#{user_id}_#{format_entity_type(entity_type)}_mask_configuration", expires_in: 30.minutes) do
        response = KylasDataMask::MaskedFields.new(api_key: api_key, entity_type: entity_type).fetch
        response[:data] if response[:success]
      end
    end

    def clear_cache_masking_configuration(entity_type, user_id)
      Rails.cache.delete("user_#{user_id}_#{format_entity_type(entity_type)}_mask_configuration")
    end

    def format_entity_type(entity_type)
      entity_type.downcase.singularize
    end
  end
end
