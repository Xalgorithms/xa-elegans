class Event < ActiveRecord::Base
  has_one :transaction_open_event
  has_one :transaction_close_event
end
