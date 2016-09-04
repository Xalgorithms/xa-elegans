class CreateRevisions < ActiveRecord::Migration
  def change
    create_table :revisions do |t|
      t.references :document, index: true, foreign_key: true
      t.references :invoice, index: true, foreign_key: true
    end
  end
end
