class CreateChanges < ActiveRecord::Migration
  def change
    create_table :changes do |t|
      t.string :document_id
      t.references :invoice, index: true, foreign_key: true
      t.references :rule, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
