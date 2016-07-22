class CreateTransformations < ActiveRecord::Migration
  def change
    create_table :transformations do |t|
      t.string :public_id
      t.string :name
    end
  end
end
