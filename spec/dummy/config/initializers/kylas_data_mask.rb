# frozen_string_literal: true

KylasDataMask::Context.setup do |config|
  config.api_url = 'https://api.kylas.io'
  config.api_version = 'v1'
  config.marketplace_app_host = 'https://www.example.com'
  config.marketplace_app_id = SecureRandom.uuid
  config.user_model_name = 'KylasEngine::User'
  config.tenant_model_name = 'KylasEngine::Tenant'
  config.webhook_api_key_column_name = 'webhook_api_key'
end
