class AddTransactionPublicIdToTransactionAssociateRuleEvent < ActiveRecord::Migration
  def change
    add_column :transaction_associate_rule_events, :transaction_public_id, :string
  end
end
