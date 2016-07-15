class CreateIdentifiers < ActiveRecord::Migration
  def change
    create_table :identifiers do |t|
      t.references :environment, index: true, foreign_key: true
    end
  end
end
