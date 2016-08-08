class TransactionSerializer
  def self.many(transactions)
    transactions.map(&self.method(:serialize))
  end

  def self.serialize(transaction)
    {
      id: transaction.public_id,
      status: Transaction::STATUSES[transaction.status],
      user: {
        email: transaction.user.email,
      },
      invoices: InvoiceSerializer.many(transaction.invoices, :transaction),
      associations: AssociationSerializer.many(transaction.associations, :transaction),
    }
  end
end
