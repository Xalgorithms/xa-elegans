require 'rails_helper'

describe Api::V1::InvoicesController, type: :controller do
  include Randomness
  include ResponseJson

  before(:all) do
    Invoice.destroy_all
    Transaction.destroy_all
  end
  
  it 'should list all Invoices for a Transaction' do
    rand_array_of_models(:transaction).each do |tm|
      invoices = rand_array_of_models(:invoice, transact_id: tm.id)
      
      get(:index, transaction_id: tm.public_id)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(InvoiceSerializer.many(invoices)))
    end
  end

  it 'should list all Invoices for a User' do
    rand_array_of_models(:user).each do |um|
      ims = rand_array_of_models(:transaction, user: um).inject([]) do |a, trm|
        a + rand_array_of_models(:invoice, transact: trm)
      end
      
      get(:index, user_id: um.id)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(InvoiceSerializer.many(ims)))
    end
  end

  it 'should fail if there is no such transaction' do
    rand_array_of_numbers.each do |transaction_id|
      get(:index, transaction_id: transaction_id)

      expect(response).to_not be_success
      expect(response).to have_http_status(:not_found)
    end
  end
end
