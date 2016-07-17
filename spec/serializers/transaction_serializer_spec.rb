require 'rails_helper'

describe TransactionSerializer do
  it 'should serialize' do
    rand_array_of_models(:user).each do |um|
      rand_array_of_models(:transaction, user: um).each do |tm|
        ex = {
          id: tm.public_id,
          status: Transaction::STATUSES[tm.status],
          user: { email: um.email },
        }
        expect(TransactionSerializer.serialize(tm)).to eql(ex)
      end
    end
  end
end
