class AddTransactionPublicIdToTransactionBindSourceEvents < ActiveRecord::Migration
  def change
    add_column :transaction_bind_source_events, :transaction_public_id, :string
  end
end
