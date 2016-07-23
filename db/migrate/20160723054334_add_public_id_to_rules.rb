class AddPublicIdToRules < ActiveRecord::Migration
  def change
    add_column :rules, :public_id, :string
  end
end
