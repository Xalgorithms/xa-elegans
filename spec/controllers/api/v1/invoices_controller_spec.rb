require 'rails_helper'

describe Api::V1::InvoicesController, type: :controller do
  include Randomness
  include ResponseJson

  it 'should list all Invoices for a Transaction' do
    rand_array_of_models(:transaction).each do |tm|
      invoices = rand_array_of_models(:invoice, transact_id: tm.id)
      
      get(:index, transaction_id: tm.id)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(InvoiceSerializer.many(invoices)))
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
