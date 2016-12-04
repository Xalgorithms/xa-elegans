class Transaction < ActiveRecord::Base
  SOURCES = [
    :tradeshift,
  ]
  
  belongs_to :user
  has_many :invoices, foreign_key: 'transact_id'
  has_many :documents, through: :invoices
  has_many :associations
  has_many :rules, through: :associations

  def as_json(opts={})
    
  end
end
