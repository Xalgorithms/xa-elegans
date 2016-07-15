class RemoveIdentifiers < ActiveRecord::Migration
  def change
    drop_table :identifiers
  end
end
