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
  
  it 'should initialize public_id if not supplied' do
    rand_array_of_uuids.each do |id|
      am = Association.create(public_id: id)
      expect(am.public_id).to eql(id)
      expect(Association.find(am.id).public_id).to eql(id)
    end

    rand_times.each do
      am = Association.create
      expect(am.public_id).to_not be_nil
      expect(Association.find(am.id).public_id).to eql(am.public_id)
    end
  end
end
