class CreateRegisterEvents < ActiveRecord::Migration
  def change
    create_table :register_events do |t|
      t.references :user, index: true
      t.string :token
    end
  end
end
