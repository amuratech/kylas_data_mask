# frozen_string_literal: true

module KylasDataMask
  class ProcessUserWebhookJob < ApplicationJob
    def perform(webhook_api_key, parameters)
      parameters = parameters.to_h.with_indifferent_access
      entity_type = parameters['entityType']&.downcase

      if webhook_api_key.blank? || entity_type.blank?
        Rails.logger.error I18n.t(
          'webhooks.webhook_api_key_or_entity_type_is_blank',
          webhook_api_key: webhook_api_key, entity_type: entity_type
        )
        return false
      end

      if entity_type != USER
        Rails.logger.error I18n.t(
          'webhooks.not_a_user_webhook',
          webhook_api_key: webhook_api_key, entity_type: entity_type
        )
        return false
      end

      tenant_model = KylasDataMask::Context.config.tenant_model_name
      webhook_api_key_column_name = KylasDataMask::Context.config.webhook_api_key_column_name
      tenant = tenant_model.constantize.find_by(webhook_api_key_column_name => webhook_api_key)

      if tenant.present?
        profile_id = parameters.dig('entity', 'profile', 'id')

        unless profile_id.nil?
          tenant.users.where(kylas_user_id: parameters.dig('entity', 'id')).update_all(kylas_profile_id: profile_id)
        end
      else
        Rails.logger.error I18n.t('webhooks.tenant_not_found', value: webhook_api_key)
        nil
      end
    end
  end
end
