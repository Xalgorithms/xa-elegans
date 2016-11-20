class RemoveTransactionPublicIdFromTransactionAssociateRuleEvents < ActiveRecord::Migration
  def change
    remove_column :transaction_associate_rule_events, :transaction_public_id, :string
  end
end
