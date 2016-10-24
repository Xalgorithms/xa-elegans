class AddPublicIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :public_id, :string
  end
end
