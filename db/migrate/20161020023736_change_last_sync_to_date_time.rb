class ChangeLastSyncToDateTime < ActiveRecord::Migration
  def change
    change_column :tradeshift_sync_states, :last_sync, :datetime  
  end
end
