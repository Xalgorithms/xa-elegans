class Event < ActiveRecord::Base
  has_one :transaction_open_event
  has_one :transaction_close_event
  has_one :transformation_add_event
  has_one :transaction_associate_rule_event
end
