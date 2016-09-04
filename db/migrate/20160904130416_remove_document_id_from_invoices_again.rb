class RemoveDocumentIdFromInvoicesAgain < ActiveRecord::Migration
  def change
    remove_column :invoices, :document_id, :string
  end
end
