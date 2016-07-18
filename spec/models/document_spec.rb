require 'rails_helper'

describe Document, type: :model do
  def with_documents
  end
  
  it 'provides some properties out of the parsed content' do
    {
      'ubl/documents/UBL-Invoice-2.1-Example.xml' => 'EUR',
      'ubl/documents/icelandic-guitar/t0.xml' => 'USD',
    }.each do |fn, cur|
      dm = Document.find(create(:document, src: IO.read(fn)).id)
      expect(dm.currency).to eql(dm.content['currency'])
      expect(dm.issued).to eql(DateTime.parse(dm.content['issued']))
      [:supplier, :customer, :payer].each do |party|
        expect(dm.send(party)).to eql(dm.content['parties'][party.to_s])
      end
      expect(dm.delivery).to eql(dm.content['delivery'])
      expect(dm.items).to eql(dm.content['lines'])
    end
  end
end
