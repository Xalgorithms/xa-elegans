class AddDocumentPublicIdToInvoicePushEvents < ActiveRecord::Migration
  def change
    add_column :invoice_push_events, :document_public_id, :string
  end
end
