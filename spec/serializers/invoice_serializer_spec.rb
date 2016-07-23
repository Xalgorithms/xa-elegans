require 'rails_helper'

describe InvoiceSerializer do
  it 'should serialize' do
    rand_array_of_models(:transaction).each do |tm|
      rand_array_of_models(:invoice, transact_id: tm.id).each do |im|
        ex = {
          id: im.public_id,
          transaction: { id: tm.public_id },
          document: DocumentSerializer.serialize(im.document),
        }
        expect(InvoiceSerializer.serialize(im)).to eql(ex)
      end
    end
  end

  it 'should serialize for a transaction container' do
    rand_array_of_models(:transaction).each do |tm|
      rand_array_of_models(:invoice, transact_id: tm.id).each do |im|
        ex = {
          id: im.public_id,
          document: DocumentSerializer.serialize(im.document),          
        }
        expect(InvoiceSerializer.serialize(im, :transaction)).to eql(ex)
      end
    end
  end
end
