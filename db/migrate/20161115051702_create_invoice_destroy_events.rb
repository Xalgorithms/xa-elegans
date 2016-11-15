class CreateInvoiceDestroyEvents < ActiveRecord::Migration
  def change
    create_table :invoice_destroy_events do |t|
      t.string :invoice_id
      t.references :event, index: true
    end
  end
end
