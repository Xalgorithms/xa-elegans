class RemoveEnviroments < ActiveRecord::Migration
  def change
    drop_table :environments
  end
end
