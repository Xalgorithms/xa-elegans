require 'rails_helper'

describe Api::V1::InvoicesController, type: :controller do
  include Randomness
  include ResponseJson

  before(:all) do
    Invoice.destroy_all
    Transaction.destroy_all
    Revision.destroy_all
    Document.destroy_all
  end
  
  it 'should list all Invoices for a Transaction' do
    rand_array_of_models(:transaction).each do |tm|
      invoices = rand_array_of_models(:invoice, transact_id: tm.id)
      
      get(:index, transaction_id: tm.public_id)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(InvoiceSerializer.many(invoices)))
    end
  end

  it 'should list all Invoices for a User' do
    rand_array_of_models(:user).each do |um|
      ims = rand_array_of_models(:transaction, user: um).inject([]) do |a, trm|
        a + rand_array_of_models(:invoice, transact: trm)
      end
      
      get(:index, user_id: um.id)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(InvoiceSerializer.many(ims)))
    end
  end

  it 'should fail if there is no such transaction' do
    rand_array_of_numbers.each do |transaction_id|
      get(:index, transaction_id: transaction_id)

      expect(response).to_not be_success
      expect(response).to have_http_status(:not_found)
    end
  end

  it 'should yield the latest associated document' do
    rand_array_of_models(:invoice).each do |im|
      pdm = Document.create(invoice: im)
      ndm = Document.create(invoice: im)

      get(:latest, invoice_id: im.public_id)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(DocumentSerializer.serialize(ndm)))
    end
  end

  it 'should yield not found for latest if the invoice has no revisions' do
    rand_array_of_models(:invoice).each do |im|
      get(:latest, invoice_id: im.public_id)

      expect(response).to_not be_success
      expect(response).to have_http_status(:not_found)
    end
  end

  it 'should yield not found for latest if the invoice does not exist' do
    rand_array_of_uuids.each do |public_id|
      get(:latest, invoice_id: public_id)

      expect(response).to_not be_success
      expect(response).to have_http_status(:not_found)
    end
  end

  it 'should show an invoice' do
    rand_array_of_models(:invoice).each do |im|
      get(:show, id: im.public_id)

      expect(response).to be_success
      expect(response_json).to eql(encode_decode(InvoiceSerializer.serialize(im)))
    end
  end

  it 'should yield not found if the invoice shown does not exist' do
    rand_array_of_uuids.each do |id|
      get(:show, id: id)

      expect(response).to_not be_success
      expect(response).to have_http_status(:not_found)
    end
  end
end
