class Rule < ActiveRecord::Base
  # strange naming b/c :transaction is a reserved method in AR::B
  belongs_to :transact, class_name: 'Transaction', foreign_key: 'transaction_id'
end
