require 'rails_helper'

describe Rule, type: :model do
  include Randomness

  before(:each) do
    Rule.destroy_all
    Transaction.destroy_all
    Association.destroy_all
  end
  
  it 'has many associations' do
    rm = create(:rule)
    ams = rand_array_of_models(:association, rule: rm)
    expect(rm.associations).to match_array(ams)
  end

  it 'has many transactions' do
    rm = create(:rule)
    trms = rand_array_of_models(:transaction)
    ams = trms.map do |trm|
      create(:association, rule: rm, transact: trm)
    end
    
    expect(rm.transactions).to match_array(trms)
  end
end
