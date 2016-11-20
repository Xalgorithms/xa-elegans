class RemoveTransactionPublicIdFromTransactionBindSourceEvents < ActiveRecord::Migration
  def change
    remove_column :transaction_bind_source_events, :transaction_public_id, :string
  end
end
