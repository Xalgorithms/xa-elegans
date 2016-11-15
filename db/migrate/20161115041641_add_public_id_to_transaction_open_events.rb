class AddPublicIdToTransactionOpenEvents < ActiveRecord::Migration
  def change
    add_column :transaction_open_events, :user_public_id, :string
  end
end
