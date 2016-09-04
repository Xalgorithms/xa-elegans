require 'rails_helper'

describe Invoice, type: :model do
  it 'has many revisions and corresponding documents' do
    rand_array_of_models(:invoice).each do |im|
      dms = rand_array_of_models(:document)
      revms = dms.map { |dm| create(:revision, document: dm, invoice: im) }
      expect(im.revisions).to match_array(revms)
      expect(im.documents).to match_array(dms)
    end
  end
end
