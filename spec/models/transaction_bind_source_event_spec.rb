require 'rails_helper'

describe TransactionBindSourceEvent, type: :model do
  include Randomness

  it 'should associate with transactions' do
    rand_array_of_models(:transaction) do |trm|
      em = TransactionBindSourceEvent.create(transact: trm)
      expect(em.transact).to eql(trm)
    end
  end

  it 'should associate with events' do
    rand_array_of_models(:event) do |em|
      tem = TransactionBindSourceEvent.create(event: em)
      expect(tem.event).to eql(em)
    end
  end
end
