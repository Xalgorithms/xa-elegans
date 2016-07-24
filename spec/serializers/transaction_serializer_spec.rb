require 'rails_helper'

describe TransactionSerializer do
  before(:each) do
    User.destroy_all
    Transaction.destroy_all
    Invoice.destroy_all
  end
  
  it 'should serialize' do
    rand_array_of_models(:user).each do |um|
      invoices = rand_array_of_models(:invoice)
      rand_array_of_models(:transaction, user: um, invoices: invoices).each do |tm|
        am = Association.create(transact: tm, transformation: create(:transformation), rule: create(:rule))
        ex = {
          id: tm.public_id,
          status: Transaction::STATUSES[tm.status],
          user: { email: um.email },
          invoices: InvoiceSerializer.many(invoices, :transaction),
          associations: AssociationSerializer.many([am], :transaction),
        }
        expect(TransactionSerializer.serialize(tm)).to eql(ex)
      end
    end
  end
end
