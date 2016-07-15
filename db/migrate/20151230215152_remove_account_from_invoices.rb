class RemoveAccountFromInvoices < ActiveRecord::Migration
  def change
    remove_reference :invoices, :account, index: true, foreign_key: true
  end
end
