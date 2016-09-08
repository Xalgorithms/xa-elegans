class CreateChangesAgain < ActiveRecord::Migration
  def change
    create_table :changes do |t|
      t.references :document, index: true
      t.jsonb :content
    end
  end
end
