class EventSerializer
  def self.serialize(event)
    @serializers = {
      transaction_open:           method(:serialize_transaction_open),
      transaction_close:          method(:serialize_transaction_close),
      invoice_push:               method(:serialize_invoice_push),
      transformation_add:         method(:serialize_transformation_add),
      transaction_associate_rule: method(:serialize_transaction_associate_rule),
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
      transformation: { url: Rails.application.routes.url_helpers.api_v1_transformation_path(event.transformation_add_event.transformation.public_id) }
    }.merge(serialize_any(event))
  end

  def self.serialize_transaction_associate_rule(event)
    {}.tap do |o|
      o[:transaction] = { id: event.transaction_associate_rule_event.transact.public_id } if event.transaction_associate_rule_event.transact
      o[:rule] = { reference: event.transaction_associate_rule_event.rule.reference } if event.transaction_associate_rule_event.rule
    end.merge(serialize_any(event))
  end
  
  def self.serialize_any(e)
    { id: e.public_id, event_type: e.event_type }
  end
end
