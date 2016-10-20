class CreateTradeshiftSyncStates < ActiveRecord::Migration
  def change
    create_table :tradeshift_sync_states do |t|
      t.date :last_sync
    end
  end
end
