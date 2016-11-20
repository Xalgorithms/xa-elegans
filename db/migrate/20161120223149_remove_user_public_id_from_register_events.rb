class RemoveUserPublicIdFromRegisterEvents < ActiveRecord::Migration
  def change
    remove_column :register_events, :user_public_id, :string
  end
end
