class RemoveRulePublicIdFromTransactionAssociateRuleEvents < ActiveRecord::Migration
  def change
    remove_column :transaction_associate_rule_events, :rule_public_id, :string
  end
end
