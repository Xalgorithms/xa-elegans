class AddInvoiceToTransactionAddInvoiceEvents < ActiveRecord::Migration
  def change
    add_reference :transaction_add_invoice_events, :invoice, index: true
  end
end
