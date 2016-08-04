class AddTransformationToTransformationAddEvents < ActiveRecord::Migration
  def change
    add_reference :transformation_add_events, :transformation, index: true
  end
end
