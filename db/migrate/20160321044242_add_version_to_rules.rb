class AddVersionToRules < ActiveRecord::Migration
  def change
    add_column :rules, :version, :string
  end
end
