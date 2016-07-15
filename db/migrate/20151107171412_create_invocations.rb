class CreateInvocations < ActiveRecord::Migration
  def change
    create_table :invocations do |t|
      t.references :account, index: true, foreign_key: true
      t.references :rule, index: true, foreign_key: true
    end
  end
end
