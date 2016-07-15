class Rule < ActiveRecord::Base
  # strange naming b/c :transaction is a reserved method in AR::B
  belongs_to :transact, class_name: 'Transaction', foreign_key: 'transaction_id'
  has_many :applied_changes, class_name: 'Change', foreign_key: 'rule_id'
end
