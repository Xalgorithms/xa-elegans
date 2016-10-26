class CreateTradeshiftSyncEvents < ActiveRecord::Migration
  def change
    create_table :tradeshift_sync_events do |t|
      t.references :event, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
    end
  end
end
