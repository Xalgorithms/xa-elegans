require 'rails_helper'

describe InvoiceService do
  after(:all) do
    Transaction.destroy_all
    Document.destroy_all
    Invoice.destroy_all
    Revision.destroy_all
    User.all
  end
  
  it 'should create invoices based on documents' do
    um = create(:user)
    rand_array_of_models(:transaction, user: um).each do |trm|
      rand_array_of_models(:document).each do |dm|
        notification_invoice_id = nil
        
        expect(NotificationService).to receive(:send) do |user_id, invoice_id, document_id|
          expect(user_id).to eql(um.id)
          expect(document_id).to eql(dm.id)
          notification_invoice_id = invoice_id
        end
        
        block_im = nil
        InvoiceService.create_from_document(trm.id, dm.id) do |im|
          block_im = im
        end

        im = Invoice.last
        expect(im).to_not be_nil
        expect(block_im).to eql(im)
        expect(notification_invoice_id).to eql(im.id)
        expect(im.transact).to eql(trm)
        expect(im.revisions.length).to eql(1)
        expect(im.revisions.first.document).to eql(dm)
      end
    end
  end
end
