class Invoice < ActiveRecord::Base
  belongs_to :transact, foreign_key: :transact_id, class_name: 'Transaction'
  has_many :revisions
  has_many :documents, through: :revisions
end
