class CreateAssigments < ActiveRecord::Migration
  def change
    create_table :assigments do |t|
      t.references :invocation, index: true, foreign_key: true
      t.references :parameter, index: true, foreign_key: true
      t.string :actual
    end
  end
end
