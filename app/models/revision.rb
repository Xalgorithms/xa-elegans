class Revision < ActiveRecord::Base
  belongs_to :document
  belongs_to :invoice
end
