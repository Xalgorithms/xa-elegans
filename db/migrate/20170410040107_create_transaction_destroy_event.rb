class CreateTransactionDestroyEvent < ActiveRecord::Migration
  def change
    create_table :transaction_destroy_events do |t|
      t.string :transaction_id
      t.references :event, index: true
    end
  end
end
