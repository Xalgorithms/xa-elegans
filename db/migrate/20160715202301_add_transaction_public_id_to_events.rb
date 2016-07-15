class AddTransactionPublicIdToEvents < ActiveRecord::Migration
  def change
    add_column :transaction_close_events, :transaction_public_id, :string
  end
end
