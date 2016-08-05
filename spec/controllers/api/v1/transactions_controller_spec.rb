require 'rails_helper'

describe Api::V1::TransactionsController, type: :controller do
  include Randomness
  include ResponseJson

  it 'should list all transactions for a User' do
    rand_times.map { create(:user) }.each do |um|
      transactions = rand_times.map { create(:transaction, user: um, status: rand_one(Transaction::STATUSES.keys)) }
      
      get(:index, user_id: um.id)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(TransactionSerializer.many(transactions)))
    end
  end

  it 'should fail if there is no such user' do
    rand_array_of_numbers.each do |user_id|
      get(:index, user_id: user_id)

      expect(response).to_not be_success
      expect(response).to have_http_status(:not_found)
    end
  end

  it 'should show transactions' do
    um = create(:user)
    rand_array_of_models(:transaction, user: um).each do |trm|
      get(:show, id: trm.public_id)
      
      expect(response).to be_success
      expect(response_json).to eql(encode_decode(TransactionSerializer.serialize(trm)))
    end
  end

  it 'should not show unknown transactions' do
    rand_array_of_uuids.each do |public_id|
      get(:show, id: public_id)
      
      expect(response).to_not be_success
    end
  end
end
