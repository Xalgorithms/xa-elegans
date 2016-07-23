class AddTransformationToTransactionAssociateRuleEvents < ActiveRecord::Migration
  def change
    add_reference :transaction_associate_rule_events, :transformation, index: true, foreign_key: true
  end
end
