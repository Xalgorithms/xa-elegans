class CreateEnvironments < ActiveRecord::Migration
  def change
    create_table :environments do |t|
      t.references :rule, index: true, foreign_key: true
    end
  end
end
