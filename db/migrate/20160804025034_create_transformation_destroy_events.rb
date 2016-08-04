class CreateTransformationDestroyEvents < ActiveRecord::Migration
  def change
    create_table :transformation_destroy_events do |t|
      t.string :public_id
      t.references :event, index: true, foreign_key: true
    end
  end
end
