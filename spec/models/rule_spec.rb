require 'rails_helper'

RSpec.describe Rule, type: :model do
  include Randomness
  
  it 'should associate with a Transaction' do
    transactions = rand_times.map { create(:transaction) }
    rand_times.each do
      t = rand_one(transactions)
      rule = create(:rule, transact: t)
      expect(rule.transact).to eql(t)
    end
  end
end
