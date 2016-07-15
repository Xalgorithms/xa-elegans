class EventService
  def self.transaction_close(e)
    if !e.transact
      e.transact = Transaction.find_by(public_id: e.transaction_public_id)
      e.save
    end
    e.transact.close if e.transact
  end
end
