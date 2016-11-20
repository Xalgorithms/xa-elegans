class RemoveTransactionPublicIdFromTransactionCloseEvents < ActiveRecord::Migration
  def change
    remove_column :transaction_close_events, :transaction_public_id, :string
  end
end
