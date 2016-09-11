require 'rails_helper'

describe Rule, type: :model do
  include Randomness

  before(:each) do
    Rule.destroy_all
    Change.destroy_all
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

  it 'can have a change' do
    expect(create(:rule).changes).to be_empty
    rand_array_of_models(:rule).each do |rm|
      chm = create(:change)
      rm.update_attributes(rule_changes: [chm])
      expect(rm.rule_changes).to include(chm)
      expect(Rule.find(rm.id).rule_changes).to include(chm)
    end
  end
end
