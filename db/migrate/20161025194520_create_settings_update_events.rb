class CreateSettingsUpdateEvents < ActiveRecord::Migration
  def change
    create_table :settings_update_events do |t|
      t.references :event, index: true
      t.references :user, index: true
      t.references :tradeshift_key, index: true
    end
  end
end
