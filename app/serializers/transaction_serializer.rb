class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :status, :n_invoices

  def status
    Transaction::STATUSES[@object.status]
  end

  def n_invoices
    @object.invoices.count
  end

  # new style
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
