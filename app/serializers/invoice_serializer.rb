class InvoiceSerializer
  def self.many(invoices, container = nil)
    invoices.map { |im| serialize(im, container) }
  end

  def self.serialize(invoice, container = nil)
    {
      id: invoice.public_id,
    }.tap do |o|
      o[:transaction] = { id: invoice.transact.public_id } unless :transaction == container || !invoice.transact
      o[:revisions] = invoice.revisions.map do |revm|
        { document: DocumentSerializer.serialize(revm.document) }
      end
    end
  end
end
