class AddTransformationToTransformationAddEvents < ActiveRecord::Migration
  def change
    add_reference :transformation_add_events, :transformation, index: true, foreign_key: true
  end
end
