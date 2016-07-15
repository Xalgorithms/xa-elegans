class AddTransactionToInvoices < ActiveRecord::Migration
  def change
    add_reference :invoices, :transaction, index: true, foreign_key: true
  end
end
