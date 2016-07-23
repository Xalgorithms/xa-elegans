class CreateTransactionAssociateRuleEvents < ActiveRecord::Migration
  def change
    create_table :transaction_associate_rule_events do |t|
      t.references :transaction, index: true, foreign_key: true
      t.references :rule, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true
    end
  end
end
