class DropOldTables < ActiveRecord::Migration
  def change
    drop_table :accounts
    drop_table :assignments
    drop_table :invocations
    drop_table :parameters
    drop_table :rules
  end
end
