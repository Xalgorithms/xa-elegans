class RemoveRuleIdFromChanges < ActiveRecord::Migration
  def change
    remove_column :changes, :rule_id, :integer
  end
end
