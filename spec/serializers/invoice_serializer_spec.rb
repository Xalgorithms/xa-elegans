require 'rails_helper'

describe InvoiceSerializer do
  it 'should serialize' do
    rand_array_of_models(:transaction).each do |tm|
      rand_array_of_models(:invoice, transact_id: tm.id).each do |im|
        revms = rand_array_of_models(:revision, invoice: im)
        ex = {
          id: im.public_id,
          transaction: { id: tm.public_id },
          revisions: revms.map do |revm|
            { document: DocumentSerializer.serialize(revm.document) }
          end,
        }
        expect(InvoiceSerializer.serialize(im)).to eql(ex)
      end
    end
  end

  it 'should serialize for a transaction container' do
    rand_array_of_models(:transaction).each do |tm|
      rand_array_of_models(:invoice, transact_id: tm.id).each do |im|
        revms = rand_array_of_models(:revision, invoice: im)
        ex = {
          id: im.public_id,
          revisions: revms.map do |revm|
            { document: DocumentSerializer.serialize(revm.document) }
          end,
        }
        expect(InvoiceSerializer.serialize(im, :transaction)).to eql(ex)
      end
    end
  end

  it 'should not serialize revisions if there is not document' do
    txm = create(:transaction)
    rand_array_of_models(:invoice, transact: txm).each do |im|
      dm = create(:document)
      revms = [create(:revision, document: dm, invoice: im), create(:revision, document: nil, invoice: im)]
      ex = {
        id: im.public_id,
        transaction: { id: txm.public_id },
        revisions: [{ document: DocumentSerializer.serialize(dm) }]
      }
      expect(InvoiceSerializer.serialize(im)).to eql(ex)
    end
  end
end
