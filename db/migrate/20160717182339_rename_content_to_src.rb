class RenameContentToSrc < ActiveRecord::Migration
  def change
    rename_column :documents, :content, :src
  end
end
