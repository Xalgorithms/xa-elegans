class EventService
  def self.process(et, args)
    self.send(et, Event.create(event_type: et), args)
  end
  
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
      InvoiceService.create_from_document(trm.id, dm.id) if dm
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
    um = User.find_by(public_id: e.user_public_id)
    if um
      e.update_attributes(user: um)
      Registration.find_or_create_by(token: e.token, user: um)
    else
      Rails.logger.warn("! failed to locate user (id=#{e.user_public_id})")
    end
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
      tka = args.fetch(:tradeshift, nil)
      tkm = TradeshiftKey.find_or_create_by(tka.slice(:key, :secret, :tenant_id).merge(user: um)) if tka
      em = SettingsUpdateEvent.create(user: um, event: bem)
    end

    em
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
end
