class RemoveTransactionIdFromRules < ActiveRecord::Migration
  def change
    remove_column :rules, :transaction_id, :integer
  end
end
