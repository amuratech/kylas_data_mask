class AddKylasProfileIdToUsersTable < ActiveRecord::Migration[7.0]
  def change
    add_column KylasDataMask::Context.config.user_model_name.tableize.parameterize(separator: '_').to_sym, :kylas_profile_id, :bigint
  end
end
