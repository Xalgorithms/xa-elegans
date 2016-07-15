class EventSerializer
  def self.serialize(event)
    @serializers = {
      transaction_open: method(:serialize_transaction_open),
      transaction_close: method(:serialize_transaction_close),
    }

    @serializers.fetch(event.event_type.to_sym, lambda { |o| {} }).call(event.send("#{event.event_type}_event"))
  end

  def self.serialize_transaction_open(event)
    {
      
    }
  end

  def self.serialize_transaction_close(event)
    {
      
    }
  end
end
