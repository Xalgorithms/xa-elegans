class CreateInvoicePushEvents < ActiveRecord::Migration
  def change
    create_table :invoice_push_events do |t|
      t.references :transaction, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true
      t.xml :content
      t.string :transaction_public_id
    end
  end
end
