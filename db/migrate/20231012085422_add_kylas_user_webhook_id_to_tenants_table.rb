class AddKylasUserWebhookIdToTenantsTable < ActiveRecord::Migration[7.0]
  def change
    add_column KylasDataMask::Context.config.tenant_model_name.tableize.parameterize(separator: '_').to_sym, :kylas_user_webhook_id, :bigint
  end
end
