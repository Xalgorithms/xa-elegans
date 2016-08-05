class TransactionOpenEvent < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  belongs_to :transact, class_name: 'Transaction', foreign_key: 'transaction_id'  
end
