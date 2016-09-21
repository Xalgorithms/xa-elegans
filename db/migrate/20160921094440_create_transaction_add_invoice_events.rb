class CreateTransactionAddInvoiceEvents < ActiveRecord::Migration
  def change
    create_table :transaction_add_invoice_events do |t|
      t.string :transaction_public_id
      t.string :url
      t.references :transaction, index: true
    end
  end
end
