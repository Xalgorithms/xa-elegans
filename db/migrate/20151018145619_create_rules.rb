class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :name
    end
  end
end
