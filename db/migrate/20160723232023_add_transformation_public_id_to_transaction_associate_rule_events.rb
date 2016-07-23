class AddTransformationPublicIdToTransactionAssociateRuleEvents < ActiveRecord::Migration
  def change
    add_column :transaction_associate_rule_events, :transformation_public_id, :string
  end
end
