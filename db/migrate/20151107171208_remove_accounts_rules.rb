class RemoveAccountsRules < ActiveRecord::Migration
  def change
    drop_table :accounts_rules
  end
end
