class AddEventToTransformationAddEvents < ActiveRecord::Migration
  def change
    add_reference :transformation_add_events, :event, index: true, foreign_key: true
  end
end
