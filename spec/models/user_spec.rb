require 'rails_helper'

describe User, type: :model do
  include Randomness

  before(:each) do
    Registration.destroy_all
    User.destroy_all
    Transaction.destroy_all
    TradeshiftKey.destroy_all
  end

  it 'has many registrations' do
    rand_array_of_models(:user).each do |um|
      rms = rand_array_of_models(:registration, user: um)
      expect(um.registrations).to match_array(rms)
    end
  end

  it 'has many transactions' do
    rand_array_of_models(:user).each do |um|
      trms = rand_array_of_models(:transaction, user: um)
      um = User.find(um.id)
      expect(um.transactions).to match_array(trms)
    end
  end

  it 'has many invoices' do
    rand_array_of_models(:user).each do |um|
      ims = rand_array_of_models(:transaction, user: um).inject([]) do |a, trm|
        a + rand_array_of_models(:invoice, transact: trm)
      end

      um = User.find(um.id)
      expect(um.invoices).to match_array(ims)
    end
  end

  it 'has a tradeshift key' do
    rand_array_of_models(:user).each do |um|
      tkm = create(:tradeshift_key, user: um)
      expect(um.tradeshift_key).to eql(tkm)
    end
  end

  it 'automatically has a public id' do
    id = UUID.generate

    um = create(:user, public_id: id)
    expect(um.public_id).to eql(id)

    rm = create(:user)
    expect(um.public_id).to_not be_nil
  end
end
