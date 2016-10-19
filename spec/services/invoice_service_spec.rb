require 'rails_helper'

describe InvoiceService do
  before(:all) do
    Transaction.destroy_all
    Document.destroy_all
    Invoice.destroy_all
    Revision.destroy_all
  end
  
  it 'should create invoices based on documents' do
    rand_array_of_models(:transaction).each do |trm|
      rand_array_of_models(:document).each do |dm|
        block_im = nil
        InvoiceService.create_from_document(trm.id, dm.id) do |im|
          block_im = im
        end

        im = Invoice.last
        expect(im).to_not be_nil
        expect(block_im).to eql(im)
        expect(im.transact).to eql(trm)
        expect(im.revisions.length).to eql(1)
        expect(im.revisions.first.document).to eql(dm)
      end
    end
  end
end
