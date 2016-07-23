class AddRulePublicIdToTransactionAssociateRuleEvent < ActiveRecord::Migration
  def change
    add_column :transaction_associate_rule_events, :rule_public_id, :string
  end
end
