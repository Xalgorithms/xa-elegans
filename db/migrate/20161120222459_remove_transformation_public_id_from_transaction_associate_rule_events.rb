class RemoveTransformationPublicIdFromTransactionAssociateRuleEvents < ActiveRecord::Migration
  def change
    remove_column :transaction_associate_rule_events, :transformation_public_id, :string
  end
end
