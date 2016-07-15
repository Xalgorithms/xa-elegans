class Rule < ActiveRecord::Base
  has_many :invocations
  has_many :accounts, through: :invocations
  has_many :parameters, dependent: :destroy
end
