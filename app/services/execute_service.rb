class ExecuteService
  def self.execute(transaction_id)
    tr = Transaction.find(transaction_id)
    Rails.logger.info("execute (transaction=#{tr.id})")
    tr.associations.each(&method(:execute_association))
  end

  private

  def self.execute_association(am)
    am.transact.invoices.each do |im|
      InterpretService.execute(im.id, am.rule.id, am.transformation.id)
    end
  end
end
