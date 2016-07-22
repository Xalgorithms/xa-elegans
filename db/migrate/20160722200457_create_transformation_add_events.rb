class CreateTransformationAddEvents < ActiveRecord::Migration
  def change
    create_table :transformation_add_events do |t|
      t.string :name
    end
  end
end
