class RemoveTransactionPublicIdFromTransactionAddInvoiceEvents < ActiveRecord::Migration
  def change
    remove_column :transaction_add_invoice_events, :transaction_public_id, :string
  end
end
