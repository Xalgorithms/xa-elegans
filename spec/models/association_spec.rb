require 'rails_helper'

describe Association, type: :model do
  include Randomness

  it 'should reference a rule' do
    rand_array_of_models(:rule) do |rm|
      am = Association.create(rule: rm)
      expect(am.rule).to eql(rm)
    end
  end

  it 'should reference a transaction' do
    rand_array_of_models(:transaction) do |trm|
      am = Association.create(transact: trm)
      expect(am.transact).to eql(trm)
    end
  end
end
