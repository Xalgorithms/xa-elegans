class EventService
  def self.transaction_open(e)
    trm = Transaction.create(user: e.user, status: Transaction::STATUS_OPEN, public_id: UUID.generate)
    e.update_attributes(transact: trm)
  end
  
  def self.transaction_close(e)
    attach_transaction(e) do |tr|
      tr.close
    end
  end

  def self.invoice_push(e)
    attach_transaction(e) do |trm|
      dm = Document.find_by(public_id: e.document_public_id)
      im = Invoice.create(transact: trm, public_id: UUID.generate)
      revm = Revision.create(document: dm, invoice: im)
      NotificationService.send(trm.user.id, im.id, dm.id) if trm.user
    end
  end

  def self.transformation_add(e)
    txm = Transformation.create(name: e.name, src: e.src, public_id: UUID.generate)
    e.update_attributes(transformation: txm)
    ParseService.parse_transformation(txm.id)
  end

  def self.transformation_destroy(e)
    trm = Transformation.find_by(public_id: e.public_id)
    trm.destroy if trm
  end

  def self.transaction_associate_rule(e)
    trm = Transaction.find_by(public_id: e.transaction_public_id)
    txm = Transformation.find_by(public_id: e.transformation_public_id)
    rm = Rule.find_by(public_id: e.rule_public_id)
    e.update_attributes(transact: trm, rule: rm, transformation: txm)

    Association.create(transact: trm, rule: rm, transformation: txm)
  end
  
  private

  def self.attach_transaction(e, &bl)
    if !e.transact
      e.update_attributes(transact: Transaction.find_by(public_id: e.transaction_public_id))
    end

    bl.call(e.transact) if bl && e.transact
  end

  def self.register(e)
    Registration.find_or_create_by(token: e.token, user: e.user)
  end

  def self.transaction_execute(e)
    attach_transaction(e) do |tr|
      ExecuteService.execute(tr.id)
    end
  end

  def self.transaction_add_invoice(e)
    attach_transaction(e) do |trm|
      DownloadService.get(e.url) do |src|
        dm = Document.create(src: src)
        im = Invoice.create(transact: trm)
        Revision.create(document: dm, invoice: im)
        InvoiceParseService.parse(dm.id)
        e.update_attributes(invoice: im, document: dm)
        NotificationService.send(trm.user.id, im.id, dm.id) if trm.user
      end
    end
  end
end
