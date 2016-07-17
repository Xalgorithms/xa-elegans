class AddDocumentToInvoices < ActiveRecord::Migration
  def change
    add_reference :invoices, :document, index: true, foreign_key: true
  end
end
