class EventService
  def self.transaction_open(e)
    Transaction.create(user: e.user, status: Transaction::STATUS_OPEN, public_id: UUID.generate)
  end
  
  def self.transaction_close(e)
    attach_transaction(e) do |tr|
      tr.close
    end
  end

  def self.invoice_push(e)
    attach_transaction(e)
    Invoice.create(transact: e.transact, document: Document.find_by(public_id: e.document_public_id), public_id: UUID.generate)
  end

  def self.transformation_add(e)
    txm = Transformation.create(name: e.name, public_id: UUID.generate)
    e.update_attributes(transformation: txm)
  end

  def self.transaction_associate_rule(e)
    trm = Transaction.find_by(public_id: e.transaction_public_id)
    rm = Rule.find_by(public_id: e.rule_public_id)
    e.update_attributes(transact: trm, rule: rm)
    Association.create(transact: trm, rule: rm)
  end
  
  private

  def self.attach_transaction(e, &bl)
    if !e.transact
      e.update_attributes(transact: Transaction.find_by(public_id: e.transaction_public_id))
    end

    bl.call(e.transact) if bl && e.transact
  end
end
