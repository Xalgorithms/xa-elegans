require 'rails_helper'

describe Transformation, type: :model do
  include Randomness
  
  after(:all) do
    Transformation.destroy_all
  end
  
  it 'should initialize public_id if not supplied' do
    rand_array_of_uuids.each do |id|
      trm = Transformation.create(public_id: id)
      expect(trm.public_id).to eql(id)
      expect(Transformation.find(trm.id).public_id).to eql(id)
    end

    rand_times.each do
      trm = Transformation.create
      expect(trm.public_id).to_not be_nil
      expect(Transformation.find(trm.id).public_id).to eql(trm.public_id)
    end
  end
end
