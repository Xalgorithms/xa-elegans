class RemoveForeignKeyDocumentsRevisions < ActiveRecord::Migration
  def change
    remove_foreign_key :revisions, column: :document_id 
  end
end
