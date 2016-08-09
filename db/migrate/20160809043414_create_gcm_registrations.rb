class CreateGcmRegistrations < ActiveRecord::Migration
  def change
    create_table :gcm_registrations do |t|
      t.string :token
    end
  end
end
