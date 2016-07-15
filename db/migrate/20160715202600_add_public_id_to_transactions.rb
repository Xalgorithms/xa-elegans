class AddPublicIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :public_id, :string
  end
end
