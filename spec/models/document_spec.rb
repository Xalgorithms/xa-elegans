require 'rails_helper'

describe Document, type: :model do
  include Randomness
  
  def with_documents
  end

  after(:all) do
    Document.destroy_all
    Change.destroy_all
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

  it 'should initialize public_id if not supplied' do
    rand_array_of_uuids.each do |id|
      dm = Document.create(public_id: id)
      expect(dm.public_id).to eql(id)
      expect(Document.find(dm.id).public_id).to eql(id)
    end

    rand_times.each do
      dm = Document.create
      expect(dm.public_id).to_not be_nil
      expect(Document.find(dm.id).public_id).to eql(dm.public_id)
    end
  end

  it 'has a revision and corresponding invoice' do
    rand_times.each do
      im = create(:invoice)
      revm = create(:revision, invoice: im)
      dm = create(:document, revision: revm)
      expect(dm.revision).to eql(revm)
      expect(dm.invoice).to eql(im)
    end
  end

  it 'can have a change' do
    expect(create(:document).change).to be_nil
    rand_array_of_models(:document).each do |dm|
      chm = create(:change)
      dm.update_attributes(change: chm)
      expect(dm.change).to eql(chm)
      expect(Document.find(dm.id).change).to eql(chm)
    end
  end

  it 'can have a tradeshift sync state' do
    expect(create(:document).tradeshift_sync_state).to be_nil
    rand_array_of_models(:document).each do |dm|
      ssm = create(:tradeshift_sync_state)
      dm.update_attributes(tradeshift_sync_state: ssm)
      expect(dm.tradeshift_sync_state).to eql(ssm)
      expect(Document.find(dm.id).tradeshift_sync_state).to eql(ssm)
    end
  end
end
