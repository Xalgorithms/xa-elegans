class RemoveTradeshiftKeyFromSettingsUpdateEvents < ActiveRecord::Migration
  def change
    remove_reference :settings_update_events, :tradeshift_key, index: true
  end
end
