class RemovePublicIdFromRules < ActiveRecord::Migration
  def change
    remove_column :rules, :public_id, :string
  end
end
