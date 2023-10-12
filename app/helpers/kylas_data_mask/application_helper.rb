# frozen_string_literal: true

module KylasDataMask
  module ApplicationHelper
    include KylasDataMask::MaskingConfigurationHelper

    def format_value_based_on_masking(entity_type, profile_id, field_names, value)
      field_is_masked?(entity_type, profile_id, field_names) ? "#{'*' * value[..-4].length}#{value[-3..]}" : value
    end

    def field_is_masked?(entity_type, profile_id, field_names)
      masked_fields_list = cache_masking_configuration(entity_type)

      return false if masked_fields_list.blank?

      masked_fields_details = masked_fields_list.select { |masked_field| field_names.include?(masked_field['name']) }

      return false if masked_fields_details.blank?

      masked_fields_details.any? do |masked_detail|
        masked_profiles = masked_detail['maskConfiguration']['profileIds']
        masked_profiles.to_a.include?(profile_id) || masked_profiles.size.zero?
      end
    end
  end
end
