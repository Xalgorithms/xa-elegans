require 'rails_helper'

describe TradeshiftKey, type: :model do
  include Randomness

  before(:each) do
    User.destroy_all
    TradeshiftKey.destroy_all
  end

  it 'belongs to a user' do
    rand_array_of_models(:user).each do |um|
      tkm = create(:tradeshift_key, user: um)
      expect(tkm.user).to eql(um)
      expect(TradeshiftKey.find(tkm.id).user).to eql(um)
    end
  end
end
