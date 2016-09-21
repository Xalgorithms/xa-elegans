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

  it 'should auto-assign public id' do
    rand_times.each do
      expect(Invoice.create.public_id).to_not be_nil
    end

    rand_times.each do
      id = UUID.generate
      expect(Invoice.create(public_id: id).public_id).to eql(id)
    end
  end
end
