class AddUserPublicIdToRegisterEvents < ActiveRecord::Migration
  def change
    add_column :register_events, :user_public_id, :string
  end
end
