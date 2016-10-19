class CreateTransactionBindSourceEvents < ActiveRecord::Migration
  def change
    create_table :transaction_bind_source_events do |t|
      t.string :source
      t.references :transaction, index: true
      t.references :event, index: true
    end
  end
end
