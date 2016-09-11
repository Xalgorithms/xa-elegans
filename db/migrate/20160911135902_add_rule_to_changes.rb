class AddRuleToChanges < ActiveRecord::Migration
  def change
    add_reference :changes, :rule, index: true
  end
end
