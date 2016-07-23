class CreateAssociations < ActiveRecord::Migration
  def change
    create_table :associations do |t|
      t.references :transaction, index: true, foreign_key: true
      t.references :rule, index: true, foreign_key: true
    end
  end
end
