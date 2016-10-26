require 'rails_helper'

describe Api::V1::EventsController, type: :controller do
  include Randomness
  include ResponseJson

  after(:all) do
    Transaction.destroy_all
    TransactionOpenEvent.destroy_all
    TransactionCloseEvent.destroy_all
    TransactionExecuteEvent.destroy_all
    TransactionAddInvoiceEvent.destroy_all
    Document.destroy_all
    Invoice.destroy_all
    Revision.destroy_all
  end
  
  it 'can open transactions' do
    rand_times.map { create(:user) }.each do |um|
      len = Transaction.all.count
      post(:create, event_type: 'transaction_open', transaction_open_event: { user_id: um.id })

      evt = TransactionOpenEvent.last
      expect(evt).to_not be_nil
      expect(evt.user).to eql(um)
      expect(evt.event).to eql(Event.last)
      expect(evt.event.public_id).to_not be_nil

      expect(Transaction.all.count).to eql(len + 1)
      expect(Transaction.last).to_not be_nil
      expect(Transaction.last.user).to eql(evt.user)
      expect(Transaction.last.status).to eql(Transaction::STATUS_OPEN)
      expect(Transaction.last.public_id).to_not be_nil
      
      expect(response).to be_success
      expect(response_json).to eql(encode_decode(url: api_v1_event_path(id: evt.event.public_id)))
    end
  end

  it 'can show transaction open events' do
    rand_times.map { create(:user) }.each do |um|
      rand_times.map { create(:transaction_open_event, transact: create(:transaction, user: um), user: um, event: create(:event, event_type: 'transaction_open')) }.each do |toem|
        get(:show, id: toem.event.public_id)
        
        expect(response).to be_success
        expect(response_json).to eql(encode_decode(EventSerializer.serialize_transaction_open(toem.event)))
      end
    end
  end

  it 'can close transactions' do
    rand_array_of_uuids.each do |public_id|
      tr = create(:transaction, public_id: public_id)
      post(:create, event_type: 'transaction_close', transaction_close_event: { transaction_public_id: public_id })

      evt = TransactionCloseEvent.last

      expect(evt).to_not be_nil
      expect(evt.transact).to eql(tr)
      expect(Transaction.find(tr.id).status).to eql(Transaction::STATUS_CLOSED)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(url: api_v1_event_path(id: evt.event.public_id)))
    end
  end

  it 'can show transaction close events' do
    rand_times.map { create(:transaction) }.each do |tr|
      rand_times.map { create(:transaction_close_event, transact: tr, event: create(:event, event_type: 'transaction_close')) }.each do |tcem|
        get(:show, id: tcem.event.public_id)
        
        expect(response).to be_success
        expect(response_json).to eql(encode_decode(EventSerializer.serialize_transaction_close(tcem.event)))
      end
    end
  end

  it 'can push invoices' do
    um = create(:user)
    rand_array_of_models(:transaction, user: um).each do |trm|
      rand_array_of_models(:document).each do |dm|
        len = Invoice.all.count

        notification_invoice_id = nil
        expect(NotificationService).to receive(:send) do |user_id, invoice_id, document_id|
          expect(user_id).to eql(um.id)
          expect(document_id).to eql(dm.id)
          notification_invoice_id = invoice_id
        end
        
        post(:create, event_type: 'invoice_push', invoice_push_event: { transaction_public_id: trm.public_id, document_public_id: dm.public_id })

        evt = InvoicePushEvent.last

        expect(evt).to_not be_nil
        expect(evt.event).to eql(Event.last)
        expect(evt.transact).to eql(trm)
        expect(evt.transaction_public_id).to eql(trm.public_id)
        expect(evt.document_public_id).to eql(dm.public_id)

        expect(response).to be_success
        expect(response_json).to eql(encode_decode(url: api_v1_event_path(id: evt.event.public_id)))

        expect(Invoice.all.count).to eql(len + 1)
        lim = Invoice.last
        expect(notification_invoice_id).to eql(lim.id)
        expect(lim.transact).to eql(trm)
        expect(lim.revisions.length).to eql(1)
        expect(lim.revisions.first.document).to eql(dm)
      end
    end
  end

  it 'can show invoice push events' do
    rand_times.map { create(:transaction) }.each do |trm|
      rand_times.map { create(:invoice_push_event, transact: trm, event: create(:event, event_type: 'invoice_push')) }.each do |ipem|
        get(:show, id: ipem.event.public_id)
        
        expect(response).to be_success
        expect(response_json).to eql(encode_decode(EventSerializer.serialize_invoice_push(ipem.event)))
      end
    end
  end

  it 'can add transformations' do
    rand_array_of_words.each do |name|
      len = Transformation.all.count

      src = Faker::Lorem.paragraph

      txm_id = nil
      expect(ParseService).to receive(:parse_transformation) do |id|
        txm_id = id
      end
      
      post(:create, event_type: 'transformation_add', transformation_add_event: { name: name, src: src })

      evt = TransformationAddEvent.last

      expect(evt).to_not be_nil
      expect(evt.event).to eql(Event.last)

      expect(Transformation.all.count).to eql(len + 1)

      txm = Transformation.last

      expect(txm).to_not be_nil
      expect(txm.name).to eql(name)
      expect(txm.src).to eql(src)
      expect(txm.public_id).to_not be_nil
      expect(evt.transformation).to eql(txm)
      expect(txm_id).to eql(txm.id)
    end
  end

  it 'can show transformation add events' do
    rand_times.map { create(:transformation_add_event, event: create(:event, event_type: 'transformation_add')) }.each do |txam|
      get(:show, id: txam.event.public_id)
        
      expect(response).to be_success
      expect(response_json).to eql(encode_decode(EventSerializer.serialize_transformation_add(txam.event)))
    end
  end

  it 'can associate rules with transactions' do
    rand_array_of_models(:transaction).each do |trm|
      rand_array_of_models(:rule).each do |rm|
        txm = create(:transformation)
        post(:create, event_type: 'transaction_associate_rule', transaction_associate_rule_event: {
               transaction_public_id: trm.public_id, rule_public_id: rm.public_id, transformation_public_id: txm.public_id
             })

        evt = TransactionAssociateRuleEvent.last

        expect(evt).to_not be_nil
        expect(evt.event).to eql(Event.last)

        expect(evt.transact).to eql(trm)
        expect(evt.rule).to eql(rm)
        expect(evt.transformation).to eql(txm)

        trm = Transaction.find(trm.id)
        rm = Rule.find(rm.id)

        am = Association.last
        expect(am.transact).to eql(trm)
        expect(am.transformation).to eql(txm)
        expect(am.rule).to eql(rm)

        expect(trm.rules.to_a).to include(rm)
        expect(rm.transactions.to_a).to include(trm)
      end
    end
  end

  it 'can show associate events' do
    rand_times.map { create(:transaction_associate_rule_event, event: create(:event, event_type: 'transaction_associate_rule')) }.each do |tarm|
      get(:show, id: tarm.event.public_id)

      tarm = TransactionAssociateRuleEvent.find(tarm.id)
      
      expect(response).to be_success
      expect(response_json).to eql(encode_decode(EventSerializer.serialize_transaction_associate_rule(tarm.event)))
    end
  end

  it 'can destroy transformations' do
    rand_array_of_models(:transformation).each do |txm|
      post(:create, event_type: 'transformation_destroy', transformation_destroy_event: {
             public_id: txm.public_id
           })

      evt = TransformationDestroyEvent.last

      expect(evt).to_not be_nil
      expect(evt.event).to eql(Event.last)

      expect { Transformation.find(txm.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  it 'can show tranformation destroy events' do
    rand_times.map { create(:transformation_destroy_event, event: create(:event, event_type: 'transformation_destroy')) }.each do |tdem|
      get(:show, id: tdem.event.public_id)

      tdem = TransformationDestroyEvent.find(tdem.id)
      
      expect(response).to be_success
      expect(response_json).to eql(encode_decode(EventSerializer.serialize_transformation_destroy(tdem.event)))
    end
  end

  it 'can create registrations' do
    rand_array_of_models(:user).each do |um|
      token = Faker::Number.hexadecimal(100)

      post(:create, event_type: 'register', register_event: {
             user_public_id: um.public_id,
             token: token,
           })

      evt = RegisterEvent.last

      expect(evt).to_not be_nil
      expect(evt.event).to eql(Event.last)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(url: api_v1_event_path(id: evt.event.public_id)))

      um = User.find(um.id)
      expect(um.registrations.count).to eql(1)
      expect(um.registrations.first.token).to eql(token)
    end
  end

  it 'does not recreate equivalent registrations' do
    rand_array_of_models(:user).each do |um|
      token = Faker::Number.hexadecimal(100)

      post(:create, event_type: 'register', register_event: {
             user_public_id: um.public_id,
             token: token,
           })

      post(:create, event_type: 'register', register_event: {
             user_public_id: um.public_id,
             token: token,
           })

      um = User.find(um.id)
      expect(um.registrations.count).to eql(1)
    end
  end

  it 'can execute transactions' do
    rand_array_of_models(:transaction).each do |trm|
      post(:create, event_type: 'transaction_execute', transaction_execute_event: {
             transaction_public_id: trm.public_id
           })

      evt = TransactionExecuteEvent.last

      expect(evt).to_not be_nil
      expect(evt.event).to eql(Event.last)
      expect(evt.transact).to eql(trm)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(url: api_v1_event_path(id: evt.event.public_id)))
    end
  end

  it 'can add invoices by url' do
    um = create(:user)
    rand_array_of_models(:transaction, user: um).each do |trm|
      url = Faker::Internet.url
      src = File.read('ubl/documents/icelandic-guitar/t0.xml')

      expect(DownloadService).to receive(:get).with(url).and_yield(src)
      notification_invoice_id = nil
      notification_document_id = nil
      expect(NotificationService).to receive(:send) do |user_id, invoice_id, document_id|
        expect(user_id).to eql(um.id)
        notification_document_id = document_id
        notification_invoice_id = invoice_id
      end


      post(:create, event_type: 'transaction_add_invoice', transaction_add_invoice_event: {
             url: url,
             transaction_public_id: trm.public_id,
           })

      evt = TransactionAddInvoiceEvent.last

      expect(evt).to_not be_nil
      expect(evt.event).to eql(Event.last)
      expect(evt.transact).to eql(trm)
      expect(evt.invoice).to eql(Invoice.last)
      expect(evt.document).to eql(Document.last)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(url: api_v1_event_path(id: evt.event.public_id)))

      trm.reload
      expect(trm.invoices.count).to eql(1)

      im = trm.invoices.last
      expect(im).to_not be_nil
      expect(im.revisions.count).to eql(1)
      expect(notification_invoice_id).to eql(im.id)

      dm = im.revisions.last.document
      expect(dm.src).to_not be_nil
      expect(notification_document_id).to eql(dm.id)

      get(:show, id: evt.event.public_id)
      
      expect(response).to be_success
      expect(response_json).to eql(encode_decode(EventSerializer.serialize_transaction_add_invoice(evt.event)))
    end
  end

  it 'can bind invoice sources' do
    rand_array_of_models(:transaction).each do |trm|
      source = rand_one(Transaction::SOURCES)
      post(:create, event_type: 'transaction_bind_source', transaction_bind_source_event: {
             transaction_public_id: trm.public_id,
             source: source,
           })

      evt = TransactionBindSourceEvent.last

      expect(evt).to_not be_nil
      expect(evt.event).to eql(Event.last)
      expect(evt.transact).to eql(trm)
      expect(evt.source).to eql(source.to_s)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(url: api_v1_event_path(id: evt.event.public_id)))

      trm.reload
      expect(trm.source).to eql(source.to_s)
    end
  end

  it 'can accept settings changes for tradeshift' do
    rand_array_of_models(:user).each do |um|
      k = Faker::Number.hexadecimal(10)
      s = Faker::Number.hexadecimal(10)
      tid = Faker::Number.hexadecimal(10)

      # randomly assign an existing value
      maybe_call do
        TradeshiftKey.create(
          key: Faker::Number.hexadecimal(10),
          secret: Faker::Number.hexadecimal(10),
          tenant_id: Faker::Number.hexadecimal(10),
          user: um
        )
      end
      
      post(:create, event_type: 'settings_update', payload: {
             user_id: um.public_id,
             tradeshift: {
               key: k,
               secret: s,
               tenant_id: tid,
             },
           })

      evt = SettingsUpdateEvent.last

      expect(evt).to_not be_nil
      expect(evt.event).to eql(Event.last)
      expect(evt.user).to eql(um)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(url: api_v1_event_path(id: evt.event.public_id)))

      um.reload
      expect(um.tradeshift_key).to_not be_nil
      expect(um.tradeshift_key.key).to eql(k)
      expect(um.tradeshift_key.secret).to eql(s)
      expect(um.tradeshift_key.tenant_id).to eql(tid)

      expect(TradeshiftKey.where(user_id: um.id).count).to eql(1)
    end
  end

  it 'can trigger a tradeshift sync' do
    rand_array_of_models(:user).each do |um|
      expect(TradeshiftWorker).to receive(:perform_async).with(um.id)
      
      post(:create, event_type: 'tradeshift_sync', payload: {
             user_id: um.public_id,
           })

      evt = TradeshiftSyncEvent.last

      expect(evt).to_not be_nil
      expect(evt.event).to eql(Event.last)
      expect(evt.user).to eql(um)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(url: api_v1_event_path(id: evt.event.public_id)))
    end
  end
end
