class AddDocumentToTradeshiftSyncStates < ActiveRecord::Migration
  def change
    add_reference :tradeshift_sync_states, :document, index: true
  end
end
