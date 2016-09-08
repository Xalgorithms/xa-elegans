require 'rails_helper'

describe Change, type: :model do
  after(:all) do
    Document.destroy_all
    Change.destroy_all
  end
  
  it 'is associated with a document' do
    rand_array_of_models(:document).each do |dm|
      chm = create(:change, document: dm)
      expect(chm.document).to eql(dm)
      expect(Change.find(chm.id).document).to eql(dm)
    end
  end
end
