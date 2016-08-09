class Registration < ActiveRecord::Base
  self.table_name = 'gcm_registrations'
  
  belongs_to :user
end
