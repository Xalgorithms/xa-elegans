class CreateTransactionCloseEvents < ActiveRecord::Migration
  def change
    create_table :transaction_close_events do |t|
      t.integer :transaction_id
      t.references :event, index: true, foreign_key: true
    end
  end
end
