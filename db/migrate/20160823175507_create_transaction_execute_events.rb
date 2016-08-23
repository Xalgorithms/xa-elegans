class CreateTransactionExecuteEvents < ActiveRecord::Migration
  def change
    create_table :transaction_execute_events do |t|
      t.references :transaction, index: true
      t.references :event, index: true
      t.string :transaction_public_id
    end
  end
end
