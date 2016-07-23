class Association < ActiveRecord::Base
  belongs_to :transact, class_name: 'Transaction', foreign_key: 'transaction_id'
  belongs_to :rule
  belongs_to :transformation
end
