class RemoveSrcFromTransformationAddEvents < ActiveRecord::Migration
  def change
    remove_column :transformation_add_events, :src, :string
  end
end
