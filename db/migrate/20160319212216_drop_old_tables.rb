class DropOldTables < ActiveRecord::Migration
  def change
    drop_table :assignments
    drop_table :invocations
    drop_table :parameters
    drop_table :rules
    drop_table :accounts
  end
end
