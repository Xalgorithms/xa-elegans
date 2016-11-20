class RemoveDocumentPublicIdFromInvoicePushEvents < ActiveRecord::Migration
  def change
    remove_column :invoice_push_events, :document_public_id, :string
  end
end
