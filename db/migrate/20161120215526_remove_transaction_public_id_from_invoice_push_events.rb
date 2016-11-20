class RemoveTransactionPublicIdFromInvoicePushEvents < ActiveRecord::Migration
  def change
    remove_column :invoice_push_events, :transaction_public_id, :string
  end
end
