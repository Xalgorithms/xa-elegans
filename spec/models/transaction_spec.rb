require 'rails_helper'

RSpec.describe Transaction, type: :model do
  include Randomness
  
  it 'should associate with many Rules' do
    transactions = rand_times(2).map { create(:transaction) }
    rand_times(20).inject({}) do |o, _|
      t = rand_one(transactions)
      rule = create(:rule, transact: t)
      o.merge(t.id => o.fetch(t.id, []) << rule.id)
    end.each do |tid, rids|
      actual = Transaction.find(tid).rules.to_a
      expected = Rule.where(id: rids).to_a

      expect(actual).to eql(expected)
    end
  end
end
