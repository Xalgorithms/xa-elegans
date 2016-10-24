class TransactionSerializer < Serializer
  def self.serialize(transaction, container=nil)
    {
      id: transaction.public_id,
      status: Transaction::STATUSES[transaction.status],
      user: {
        email: transaction.user.email,
      },
      invoices: InvoiceSerializer.many(transaction.invoices, :transaction),
      associations: AssociationSerializer.many(transaction.associations, :transaction),
    }.tap do |o|
      o[:source] = transaction.source if transaction.source
    end
  end
end
