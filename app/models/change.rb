class Change < ActiveRecord::Base
  belongs_to :document
  belongs_to :rule
end
