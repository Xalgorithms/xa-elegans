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
end
