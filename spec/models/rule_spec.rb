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

  it 'is associated with many changes' do
    rand_times.each do
      changes = rand_array { create(:change) }
      r = create(:rule, applied_changes: changes)
      expect(r.applied_changes.to_a).to eql(changes)
    end
  end
end
