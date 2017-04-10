class TransactionDestroyEvent < ActiveRecord::Base
  belongs_to :event
  belongs_to :transact, class_name: 'Transaction', foreign_key: 'transaction_id'
end
