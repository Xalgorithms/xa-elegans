class EventSerializer < Serializer
  def self.serialize(event, container=nil)
    @serializers = {
      transaction_open:           method(:serialize_transaction_open),
      invoice_push:               method(:serialize_invoice_push),
      transformation_add:         method(:serialize_transformation_add),
      transformation_destroy:     method(:serialize_transformation_destroy),
      transaction_associate_rule: method(:serialize_transaction_associate_rule),
      transaction_add_invoice:    method(:serialize_transaction_add_invoice),
      transaction_bind_source:    method(:serialize_transaction_bind_source),
      transaction_destroy:        method(:serialize_transaction_destroy),
    }

    @serializers.fetch(event.event_type.to_sym, lambda { |o| {} }).call(event)
  end

  def self.serialize_transaction_open(event)
    {
      user: {
        id: event.transaction_open_event.user.id,
        email: event.transaction_open_event.user.email,
      },
      transaction: { url: Rails.application.routes.url_helpers.api_v1_transaction_path(event.transaction_open_event.transact.public_id) },
    }.merge(serialize_any(event))
  end

  def self.serialize_transaction_destroy(event)
    {
      transaction: { id: event.transaction_destroy_event.transaction_id },
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
  
  def self.serialize_transformation_destroy(event)
    {
      transformation: { id: event.transformation_destroy_event.public_id },
    }.merge(serialize_any(event))
  end

  def self.serialize_transaction_associate_rule(event)
    {}.tap do |o|
      o[:transaction] = {
        id: event.transaction_associate_rule_event.transact.public_id,
        url: Rails.application.routes.url_helpers.api_v1_transaction_path(event.transaction_associate_rule_event.transact.public_id),
      } if event.transaction_associate_rule_event.transact
      o[:rule] = { reference: event.transaction_associate_rule_event.rule.reference } if event.transaction_associate_rule_event.rule
      o[:transformation] = { name: event.transaction_associate_rule_event.transformation.name } if event.transaction_associate_rule_event.transformation
    end.merge(serialize_any(event))
  end

  def self.serialize_transaction_add_invoice(event)
    {}.tap do |o|
      o[:transaction] = {
        id: event.transaction_add_invoice_event.transact.public_id,
        url: Rails.application.routes.url_helpers.api_v1_transaction_path(event.transaction_add_invoice_event.transact.public_id),
      } if event.transaction_add_invoice_event.transact
      o[:invoice] = {
        id: event.transaction_add_invoice_event.invoice.public_id,
        url: Rails.application.routes.url_helpers.api_v1_invoice_path(event.transaction_add_invoice_event.invoice.public_id),
      } if event.transaction_add_invoice_event.invoice
      o[:document] = {
        id: event.transaction_add_invoice_event.document.public_id,
        url: Rails.application.routes.url_helpers.api_v1_document_path(event.transaction_add_invoice_event.document.public_id),
      } if event.transaction_add_invoice_event.document
    end.merge(serialize_any(event))
  end
  
  def self.serialize_transaction_bind_source(event)
    {}.tap do |o|
      o[:transaction] = {
        id: event.transaction_bind_source_event.transact.public_id,
        url: Rails.application.routes.url_helpers.api_v1_transaction_path(event.transaction_bind_source_event.transact.public_id),
      } if event.transaction_bind_source_event.transact
      o[:source] = event.transaction_bind_source_event.source
    end.merge(serialize_any(event))
  end

  def self.serialize_any(e)
    { id: e.public_id, event_type: e.event_type }
  end
end
