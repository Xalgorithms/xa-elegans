class InvoiceService
  def self.create_from_document(transaction_id, document_id, &bl)
    Rails.logger.info("creating invoice (transaction=#{transaction_id}; document=#{document_id})")

    trm = Transaction.find(transaction_id)
    im = Invoice.create(transact_id: transaction_id)
    revm = Revision.create(document_id: document_id, invoice: im)
    if trm.user
      NotificationService.send(trm.user.id, im.id, document_id)
    end
    bl.call(im) if bl
  end
end
