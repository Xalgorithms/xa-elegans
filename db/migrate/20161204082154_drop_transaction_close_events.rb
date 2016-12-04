class DropTransactionCloseEvents < ActiveRecord::Migration
  def change
    drop_table :transaction_close_events
  end
end
