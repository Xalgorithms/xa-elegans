class Transaction < ActiveRecord::Base
  STATUS_OPEN   = 0 
  STATUS_CLOSED = 1
  
  belongs_to :user
  has_many :invoices, foreign_key: 'transact_id'
end
