class RemoveVersionFromRules < ActiveRecord::Migration
  def change
    remove_column :rules, :version, :string
  end
end
