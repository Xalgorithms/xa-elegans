class CreateNewRulesTable < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :public_id
      t.references :transaction, index: true, foreign_key: true
    end
  end
end
