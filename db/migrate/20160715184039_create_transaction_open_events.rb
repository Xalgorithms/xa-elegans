class CreateTransactionOpenEvents < ActiveRecord::Migration
  def change
    create_table :transaction_open_events do |t|
      t.integer :user_id
      t.references :event, index: true, foreign_key: true
    end
  end
end
