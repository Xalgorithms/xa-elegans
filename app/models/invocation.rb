class Invocation < ActiveRecord::Base
  belongs_to :account
  belongs_to :rule
  has_many :assignments, dependent: :destroy

  accepts_nested_attributes_for :assignments
end
