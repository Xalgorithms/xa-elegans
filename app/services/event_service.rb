class EventService
  def self.process(et, args)
    self.send(et, Event.create(event_type: et), args)
  end
  
  private

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
    trm = Transaction.create(user: um, public_id: UUID.generate)
    TransactionOpenEvent.create(transact: trm, user: um, event: bem)
  end

  def self.with_transaction(args, k=:transaction_id)
    txm = Transaction.find_by(public_id: args.fetch(k, nil))
    rv = nil
    rv = yield(txm) if txm
    rv
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

  def self.transaction_execute(bem, args)
    with_transaction(args) do |txm|
      ExecuteService.execute(txm.id)
      TransactionExecuteEvent.create(transact: txm, event: bem)
    end
  end

  def self.transaction_destroy(bem, args)
    with_transaction(args) do |txm|
      public_id = txm.public_id
      txm.invoices.destroy_all
      txm.associations.destroy_all
      txm.destroy
      TransactionDestroyEvent.create(transaction_id: public_id, event: bem)
    end
  end

  def self.transaction_add_invoice(bem, args)
    with_transaction(args) do |txm|
      url = args.fetch(:url, nil)
      em = TransactionAddInvoiceEvent.create(url: url, transact: txm, event: bem)

      DownloadService.get(url) do |src|
        dm = Document.create(src: src)
        InvoiceService.create_from_document(txm.id, dm.id) do |im|
          em.update_attributes(invoice: im, document: dm)
        end
      end

      em
    end
  end

  def self.transaction_bind_source(bem, args)
    with_transaction(args) do |txm|
      source = args.fetch(:source, nil)
      txm.update_attributes(source: source.to_sym) if source
      TransactionBindSourceEvent.create(source: source, transact: txm, event: bem)
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

  def self.rule_cache_clear(bem, args)
    # drop all associations and rules
    Association.destroy_all
    Rule.destroy_all
    SyncAttempt.destroy_all
    RuleCacheClearEvent.create(event: bem)
  end
end
