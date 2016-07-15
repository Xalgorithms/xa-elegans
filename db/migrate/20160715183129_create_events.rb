class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :public_id
    end
  end
end
