class AddSrcToTransformationAddEvents < ActiveRecord::Migration
  def change
    add_column :transformation_add_events, :src, :string
  end
end
