require 'rails_helper'

describe EventSerializer do
  it 'should serialize TransactionOpenEvent' do
    rand_array_of_models(:user).each do |um|
      rand_array_of_models(:transaction_open_event, user: um).each do |toe|
        ex = {
          id:         toe.event.public_id,
          event_type: 'transaction_open',
          user:       { id: um.id, email: um.email },
        }
        expect(EventSerializer.serialize(toe.event)).to eql(ex)
      end
    end
  end

  it 'should serialize TransactionCloseEvent' do
    rand_array_of_models(:transaction).each do |tm|
      rand_array_of_models(:transaction_close_event, transact: tm).each do |tce|
        ex = {
          id:          tce.event.public_id,
          event_type:  'transaction_close',
          transaction: { id: tm.public_id },
        }
        expect(EventSerializer.serialize(tce.event)).to eql(ex)
      end
    end
  end

  it 'should serialize InvoicePushEvent' do
    rand_array_of_models(:transaction).each do |tm|
      rand_array_of_models(:invoice_push_event, transact: tm).each do |ipe|
        ex = {
          id:          ipe.event.public_id,
          event_type:  'invoice_push',
        }
        expect(EventSerializer.serialize(ipe.event)).to eql(ex)
      end
    end
  end

  it 'should serialize TransformationAddEvent' do
    rand_array_of_models(:transformation_add_event).each do |txam|
      ex = {
        transformation: { url: Rails.application.routes.url_helpers.api_v1_transformation_path(txam.transformation.public_id) },
        id: txam.event.public_id,
        event_type: 'transformation_add',
      }
      expect(EventSerializer.serialize(txam.event)).to eql(ex)
    end
  end

  it 'should serialize TransactionAssociateRuleEvent' do
    rand_array_of_models(:transaction_associate_rule_event).each do |tarem|
      tarem.transact = create(:transaction)
      tarem.rule = create(:rule)
      ex = {
        transaction: { id: tarem.transact.public_id },
        rule: { reference: tarem.rule.reference },
        id: tarem.event.public_id,
        event_type: 'transaction_associate_rule',
      }
      expect(EventSerializer.serialize(tarem.event)).to eql(ex)
    end
  end

  it 'should serialize TransformationDestroyEvent' do
    rand_array_of_models(:transformation_destroy_event).each do |tdem|
      ex = {
        transformation: { id: tdem.public_id },
        id: tdem.event.public_id,
        event_type: 'transformation_destroy',
      }
      expect(EventSerializer.serialize(tdem.event)).to eql(ex)
    end
  end
end
