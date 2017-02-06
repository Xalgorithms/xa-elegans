class Event < ActiveRecord::Base
  has_one :transaction_open_event
  has_one :transformation_add_event
  has_one :transformation_destroy_event
  has_one :transaction_associate_rule_event
  has_one :transaction_add_invoice_event
  has_one :transaction_bind_source_event
  has_one :settings_update_event
  has_one :rule_cache_clear_event

  def initialize(*args)
    super(*args)
    self.public_id ||= UUID.generate
  end
end
