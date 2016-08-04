class AddSrcToTransformations < ActiveRecord::Migration
  def change
    add_column :transformations, :src, :string
  end
end
