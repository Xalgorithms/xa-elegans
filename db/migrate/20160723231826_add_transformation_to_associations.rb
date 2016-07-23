class AddTransformationToAssociations < ActiveRecord::Migration
  def change
    add_reference :associations, :transformation, index: true, foreign_key: true
  end
end
