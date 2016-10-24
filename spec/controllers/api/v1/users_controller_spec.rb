require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  include Randomness
  include ResponseJson

  it 'should show basic user info by email or public id' do
    rand_array_of_models(:user).each do |um|
      get(:show, id: um.public_id)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(UserSerializer.serialize(um)))
                                   
      get(:show, id: um.email)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(UserSerializer.serialize(um)))
    end
  end
end
