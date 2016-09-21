class AddDocumentToTransactionAddInvoiceEvents < ActiveRecord::Migration
  def change
    add_reference :transaction_add_invoice_events, :document, index: true
  end
end
