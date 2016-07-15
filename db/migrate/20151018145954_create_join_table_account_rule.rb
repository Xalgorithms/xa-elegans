class CreateJoinTableAccountRule < ActiveRecord::Migration
  def change
    create_join_table :accounts, :rules do |t|
      # t.index [:account_id, :rule_id]
      # t.index [:rule_id, :account_id]
    end
  end
end
