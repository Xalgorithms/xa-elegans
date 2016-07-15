class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :account, index: true, foreign_key: true
      t.date :effective
    end
  end
end
