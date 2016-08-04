class AddContentToTransformations < ActiveRecord::Migration
  def change
    add_column :transformations, :content, :jsonb
  end
end
