class AddEventToTransactionAddInvoiceEvents < ActiveRecord::Migration
  def change
    add_reference :transaction_add_invoice_events, :event, index: true
  end
end
