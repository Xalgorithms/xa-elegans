class InvoiceSerializer
  def self.many(invoices)
    invoices.map(&self.method(:serialize))
  end

  def self.serialize(invoice)
    {
      id: invoice.public_id,
      transaction: { id: invoice.transact.public_id },
    }
  end
end
