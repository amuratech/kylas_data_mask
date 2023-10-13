# frozen_string_literal: true

module KylasDataMask
  module ApplicationHelper
    include KylasDataMask::MaskingConfigurationHelper

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
      when PHONE_MASKING
        if value.start_with?('+')
          parsed_number = Phonelib.parse(value)
          country_code = parsed_number.country_code
          number_without_country_code = parsed_number.national(false).to_s[1..-1]
          "+#{country_code}****#{number_without_country_code.to_s[-3..]}"
        else
          "****#{value[-3..]}"
        end
      end
    rescue StandardError => e
      Rails.logger.error "KylasDataMask -> masking_based_on_type -> Error Message: #{e.message}"

      "****#{value[-3..]}"
    end
  end
end
