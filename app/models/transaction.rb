class Transaction < ActiveRecord::Base
  STATUS_OPEN   = 0 
  STATUS_CLOSED = 1
  
  STATUSES = {
    STATUS_OPEN   => :open,
    STATUS_CLOSED => :closed,
  }
  
  belongs_to :user
  has_many :invoices, foreign_key: 'transact_id'
  has_many :rules

  def as_json(opts={})
    
  end

  def close
    update_attributes(status: STATUS_CLOSED)
  end
end
