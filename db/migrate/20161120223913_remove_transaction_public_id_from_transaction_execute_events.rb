class RemoveTransactionPublicIdFromTransactionExecuteEvents < ActiveRecord::Migration
  def change
    remove_column :transaction_execute_events, :transaction_public_id, :string
  end
end
