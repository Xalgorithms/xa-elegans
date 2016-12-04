class RemoveStatusFromTransactions < ActiveRecord::Migration
  def change
    remove_column :transactions, :status, :integer
  end
end
