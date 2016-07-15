class Change < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :rule
end
