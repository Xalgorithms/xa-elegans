class RemoveEffectiveFromInvoices < ActiveRecord::Migration
  def change
    remove_column :invoices, :effective, :date
  end
end
