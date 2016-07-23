class AddReferenceToRules < ActiveRecord::Migration
  def change
    add_column :rules, :reference, :string
  end
end
