require 'rails_helper'

describe Transaction, type: :model do
  include Randomness

  before(:each) do
    Rule.destroy_all
    Transaction.destroy_all
    Association.destroy_all
  end

  it 'has many associations' do
    trm = create(:transaction)
    ams = rand_array_of_models(:association, transact: trm)
    expect(trm.associations).to match_array(ams)
  end

  it 'has many rules' do
    trm = create(:transaction)
    rms = rand_array_of_models(:rule)
    ams = rms.map do |rm|
      create(:association, rule: rm, transact: trm)
    end
    
    expect(trm.rules).to match_array(rms)
  end
end
