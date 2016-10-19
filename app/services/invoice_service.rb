class InvoiceService
  def self.create_from_document(transaction_id, document_id, &bl)
    im = Invoice.create(transact_id: transaction_id)
    revm = Revision.create(document_id: document_id, invoice: im)
    bl.call(im) if bl
  end
end
