class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.references :rule, index: true, foreign_key: true
      t.string :name
    end
  end
end
