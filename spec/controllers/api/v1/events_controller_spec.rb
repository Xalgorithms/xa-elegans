require 'rails_helper'

describe Api::V1::EventsController, type: :controller do
  include Randomness
  include ResponseJson

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
        expect(notification_invoice_id).to eql(Invoice.last.id)
        expect(Invoice.last.transact).to eql(trm)
        expect(Invoice.last.document).to eql(dm)
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
             user_id: um.id,
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
end
