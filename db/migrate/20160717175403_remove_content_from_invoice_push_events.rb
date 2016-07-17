class RemoveContentFromInvoicePushEvents < ActiveRecord::Migration
  def change
    remove_column :invoice_push_events, :content, :xml
  end
end
