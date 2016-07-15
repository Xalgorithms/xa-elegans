class RenameAssigmentsToAssignments < ActiveRecord::Migration
  def change
    rename_table :assigments, :assignments
  end
end
