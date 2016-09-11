class Rule < ActiveRecord::Base
  has_many :associations
  has_many :transactions, through: :associations, source: :transact
  has_many :rule_changes, foreign_key: :rule_id, class_name: 'Change'
end
