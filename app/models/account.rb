class Account < ActiveRecord::Base
  belongs_to :user
  has_many :invocations
  has_many :rules, through: :invocations
  has_many :invoices
end
