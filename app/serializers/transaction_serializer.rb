class TransactionSerializer
  def self.many(transactions)
    transactions.map(&self.method(:serialize))
  end

  def self.serialize(transaction)
    {
      id: transaction.id,
      status: Transaction::STATUSES[transaction.status],
      user: {
        email: transaction.user.email,
      }
    }
  end
end
