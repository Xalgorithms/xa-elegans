class AddEventToRegisterEvents < ActiveRecord::Migration
  def change
    add_reference :register_events, :event, index: true
  end
end
