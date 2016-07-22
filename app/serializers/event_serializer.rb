class EventSerializer
  def self.serialize(event)
    @serializers = {
      transaction_open:   method(:serialize_transaction_open),
      transaction_close:  method(:serialize_transaction_close),
      invoice_push:       method(:serialize_invoice_push),
      transformation_add: method(:serialize_transformation_add),
    }

    @serializers.fetch(event.event_type.to_sym, lambda { |o| {} }).call(event)
  end

  def self.serialize_transaction_open(event)
    {
      user: {
        id: event.transaction_open_event.user.id,
        email: event.transaction_open_event.user.email,
      },
    }.merge(serialize_any(event))
  end

  def self.serialize_transaction_close(event)
    {
      transaction: {
        id: event.transaction_close_event.transact.public_id,
      },
    }.merge(serialize_any(event))
  end

  def self.serialize_invoice_push(event)
    {
    }.merge(serialize_any(event))
  end

  def self.serialize_transformation_add(event)
    {
      
    }.merge(serialize_any(event))
  end
  
  def self.serialize_any(e)
    { id: e.public_id, event_type: e.event_type }
  end
end
