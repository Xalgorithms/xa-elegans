class RemoveUserPublicIdFromTransactionOpenEvents < ActiveRecord::Migration
  def change
    remove_column :transaction_open_events, :user_public_id, :string
  end
end
