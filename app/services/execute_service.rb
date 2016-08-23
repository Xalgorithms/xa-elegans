class ExecuteService
  def self.execute(transaction_id)
    tr = Transaction.find(transaction_id)
    Rails.logger.info("execute (transaction=#{tr.id})")
  end
end
