class Invoice < ActiveRecord::Base
  belongs_to :transact, foreign_key: :transact_id, class_name: 'Transaction'
end
