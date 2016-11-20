class RemoveNameFromTransformationAddEvents < ActiveRecord::Migration
  def change
    remove_column :transformation_add_events, :name, :string
  end
end
