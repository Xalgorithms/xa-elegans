class AddUserToGcmRegistrations < ActiveRecord::Migration
  def change
    add_reference :gcm_registrations, :user, index: true
  end
end
