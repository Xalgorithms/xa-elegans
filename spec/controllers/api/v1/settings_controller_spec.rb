require 'rails_helper'

describe Api::V1::SettingsController, type: :controller do
  include Randomness
  include ResponseJson

  after(:all) do
    User.destroy_all
  end
  
  it 'should return tradeshift settings for a user' do
    rand_array_of_models(:user).each do |um|
      get(:index, user_id: um.public_id)
      
      expect(response).to be_success
      expect(response_json).to eql(encode_decode({}))

      tkm = create(:tradeshift_key, user: um)

      get(:index, user_id: um.public_id)
      
      expect(response).to be_success
      expect(response_json).to eql(encode_decode(tradeshift: TradeshiftKeySerializer.serialize(tkm)))
    end
  end

  it 'should not found if the user does not exist' do
    rand_array_of_uuids.each do |id|
      get(:index, user_id: id)
      expect(response).to_not be_success
      expect(response).to have_http_status(:not_found)
    end
  end
end
