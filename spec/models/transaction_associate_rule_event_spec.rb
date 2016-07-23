require 'rails_helper'

describe TransactionAssociateRuleEvent, type: :model do
  include Randomness

  it 'should associate with transactions' do
    rand_array_of_models(:transaction) do |trm|
      em = TransactionAssociateRuleEvent.create(transact: trm)
      expect(em.transact).to eql(trm)
    end
  end

  it 'should associate with events' do
    rand_array_of_models(:event) do |em|
      tem = TransactionAssociateRuleEvent.create(event: em)
      expect(tem.event).to eql(em)
    end
  end

  it 'should associate with rules' do
    rand_array_of_models(:rule) do |rm|
      em = TransactionAssociateRuleEvent.create(rule: rm)
      expect(em.rule).to eql(rm)
    end
  end

  it 'should associate with transformations' do
    rand_array_of_models(:transformation) do |txm|
      em = TransactionAssociateRuleEvent.create(transformation: txm)
      expect(em.transformation).to eql(txm)
    end
  end

  it 'should trigger the EventService' do
    expect(EventService).to receive(:transaction_associate_rule)
    TransactionAssociateRuleEvent.create
  end
end
