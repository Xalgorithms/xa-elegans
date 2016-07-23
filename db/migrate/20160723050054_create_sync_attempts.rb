class CreateSyncAttempts < ActiveRecord::Migration
  def change
    create_table :sync_attempts do |t|
      t.string :token
    end
  end
end
