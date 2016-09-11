require 'rails_helper'

describe Change, type: :model do
  after(:all) do
    Document.destroy_all
    Rule.destroy_all
    Change.destroy_all
  end
  
  it 'is associated with a document' do
    rand_array_of_models(:document).each do |dm|
      chm = create(:change, document: dm)
      expect(chm.document).to eql(dm)
      expect(Change.find(chm.id).document).to eql(dm)
    end
  end

  it 'is associated with a rule' do
    rand_array_of_models(:rule).each do |rm|
      chm = create(:change, rule: rm)
      expect(chm.rule).to eql(rm)
      expect(Change.find(chm.id).rule).to eql(rm)
    end
  end
end
