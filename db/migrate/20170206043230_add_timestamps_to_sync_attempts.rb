class AddTimestampsToSyncAttempts < ActiveRecord::Migration
  def change
    change_table :sync_attempts do |t|
      t.timestamps
    end
  end
end
