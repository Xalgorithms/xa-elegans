class EventService
  def self.process(et, args)
    self.send(et, Event.create(event_type: et), args)
  end
  
  private

  def self.attach_transaction(e, &bl)
    if !e.transact
      e.update_attributes(transact: Transaction.find_by(public_id: e.transaction_public_id))
    end

    bl.call(e.transact) if bl && e.transact
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
        InvoiceService.create_from_document(trm.id, dm.id) do |im|
          e.update_attributes(invoice: im, document: dm)
        end
      end
    end
  end

  def self.transaction_bind_source(e)
    attach_transaction(e) do |trm|
      trm.update_attributes(source: e.source.to_sym) if e.source
    end
  end

  def self.settings_update(bem, args)
    um = User.find_by(public_id: args.fetch(:user_id, nil))
    em = nil
    if um
      em = SettingsUpdateEvent.create(user: um, event: bem)
      tka = args.fetch(:tradeshift, nil)
      tkm = um.tradeshift_key
      tkm = TradeshiftKey.create(user: um) unless tkm
      tkm.update_attributes(tka) if tka
    end

    em
  end

  def self.transaction_open(bem, args)
    user_public_id = args.fetch(:user_id, nil)
    um = User.find_by(public_id: user_public_id)
    trm = Transaction.create(user: um, status: Transaction::STATUS_OPEN, public_id: UUID.generate)
    TransactionOpenEvent.create(transact: trm, user: um, event: bem)
  end

  def self.with_transaction(args, k=:transaction_id)
    txm = Transaction.find_by(public_id: args.fetch(k, nil))
    rv = nil
    rv = yield(txm) if txm
    rv
  end
  
  def self.transaction_close(bem, args)
    with_transaction(args) do |txm|
      txm.close
      TransactionCloseEvent.create(transact: txm, event: bem)
    end
  end

  def self.invoice_push(bem, args)
    with_transaction(args) do |txm|
      dm = Document.find_by(public_id: args.fetch(:document_id, nil))
      InvoiceService.create_from_document(txm.id, dm.id) if dm && txm
      InvoicePushEvent.create(transact: txm, document: dm, event: bem)
    end
  end

  def self.transformation_add(bem, args)
    trm = Transformation.create(name: args.fetch(:name, nil), src: args.fetch('src', ''))
    ParseService.parse_transformation(trm.id)
    TransformationAddEvent.create(transformation: trm, event: bem)
  end

  def self.transformation_destroy(bem, args)
    public_id = args.fetch(:transformation_id, nil)
    trm = Transformation.find_by(public_id: public_id)
    trm.destroy if trm
    TransformationDestroyEvent.create(public_id: public_id, event: bem)
  end
  
  def self.transaction_associate_rule(bem, args)
    with_transaction(args) do |txm|
      trm = Transformation.find_by(public_id: args.fetch(:transformation_id, nil))
      rm = Rule.find_by(public_id: args.fetch(:rule_id, nil))
      Association.create(transact: txm, rule: rm, transformation: trm)
      TransactionAssociateRuleEvent.create(transact: txm, transformation: trm, rule: rm, event: bem)
    end
  end

  def self.register(bem, args)
    um = User.find_by(public_id: args.fetch(:user_id, nil))
    if um
      token = args.fetch(:token, '')
      Registration.find_or_create_by(token: token, user: um)
      RegisterEvent.create(token: token, user: um, event: bem)
    else
      Rails.logger.warn("! failed to locate user (id=#{e.user_public_id})")
    end
  end

  def self.tradeshift_sync(bem, args)
    em = nil
    um = User.find_by(public_id: args.fetch(:user_id, nil))
    if um
      em = TradeshiftSyncEvent.create(user: um, event: bem)
      TradeshiftWorker.perform_async(um.id)
    end

    em
  end

  def self.invoice_destroy(bem, args)
    em = nil
    im = Invoice.find_by(public_id: args.fetch(:invoice_id, nil))
    if im
      em = InvoiceDestroyEvent.create(invoice_id: im.public_id, event: bem)
      im.documents.each(&:destroy)
      im.destroy
    end
    em
  end
end
