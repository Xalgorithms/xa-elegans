class AddTransactionToTransactionOpenEvent < ActiveRecord::Migration
  def change
    add_reference :transaction_open_events, :transaction, index: true
  end
end
