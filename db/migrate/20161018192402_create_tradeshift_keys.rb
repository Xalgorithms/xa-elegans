class CreateTradeshiftKeys < ActiveRecord::Migration
  def change
    create_table :tradeshift_keys do |t|
      t.string :key
      t.string :secret
      t.string :tenant_id
      t.references :user, index: true, foreign_key: true
    end
  end
end
