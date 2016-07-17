class AddPublicIdToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :public_id, :string
  end
end
