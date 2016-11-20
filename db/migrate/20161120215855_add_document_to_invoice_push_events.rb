class AddDocumentToInvoicePushEvents < ActiveRecord::Migration
  def change
    add_reference :invoice_push_events, :document, index: true
  end
end
