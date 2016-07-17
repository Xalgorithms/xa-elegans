class EventService
  def self.transaction_open(e)
    Transaction.create(user: e.user, status: Transaction::STATUS_OPEN)
  end
  
  def self.transaction_close(e)
    if !e.transact
      e.update_attributes(transact: Transaction.find_by(public_id: e.transaction_public_id))
    end
    e.transact.close if e.transact
  end

  def self.invoice_push(e)
    if !e.transact
      e.update_attributes(transact: Transaction.find_by(public_id: e.transaction_public_id))
    end
    InvoiceParseService.parse(e.id)
  end
end
