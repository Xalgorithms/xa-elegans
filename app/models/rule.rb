class Rule < ActiveRecord::Base
  has_many :associations
  has_many :transactions, through: :associations, source: :transact
end
