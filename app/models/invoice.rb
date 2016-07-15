class Invoice < ActiveRecord::Base
  belongs_to :account
end
