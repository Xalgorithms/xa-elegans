class AddPublicIdToAssociations < ActiveRecord::Migration
  def change
    add_column :associations, :public_id, :string
  end
end
