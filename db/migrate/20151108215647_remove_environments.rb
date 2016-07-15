class RemoveEnvironments < ActiveRecord::Migration
  def change
    drop_table :environments
  end
end
