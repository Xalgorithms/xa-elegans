require 'rails_helper'

describe Api::V1::TransformationsController, type: :controller do
  include Randomness
  include ResponseJson

  it 'should show specific transformations' do
    rand_array_of_models(:transformation).each do |txm|
      get(:show, id: txm.public_id)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(TransformationSerializer.serialize(txm)))      
    end
  end

  it 'should yield error when a transformation cannot be found' do
    rand_array_of_uuids.each do |public_id|
      get(:show, id: public_id)

      expect(response).to_not be_success
      expect(response).to have_http_status(:not_found)
    end
  end
end
