require 'rails_helper'

describe InvoiceSerializer do
  it 'should serialize' do
    rand_array_of_models(:transaction).each do |tm|
      rand_array_of_models(:invoice, transact_id: tm.id).each do |im|
        ex = {
          id: im.public_id,
          transaction: { id: tm.public_id },
        }
        expect(InvoiceSerializer.serialize(im)).to eql(ex)
      end
    end
  end
end
