class CreateKylasEngineTenants < ActiveRecord::Migration[7.0]
  def change
    create_table :kylas_engine_tenants do |t|
      t.timestamps
    end

    add_reference :kylas_engine_users, :tenant, foreign_key: { to_table: :kylas_engine_tenants }, index: true
  end
end
