class AddDocumentIdToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :document_id, :string
  end
end
