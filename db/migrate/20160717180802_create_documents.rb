class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.xml :content
      t.string :public_id
    end
  end
end
