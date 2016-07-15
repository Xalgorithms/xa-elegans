class RenameInvoicesTransaction < ActiveRecord::Migration
  def change
    change_table :invoices do |t|
      t.rename :transaction_id, :transact_id
    end
  end
end
