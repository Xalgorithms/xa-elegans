FactoryGirl.define do
  factory :transaction_add_invoice_event do
    event { create(:event, event_type: 'transaction_add_invoice') }
    transact { create(:transaction) }
    invoice { create(:invoice) }
    document { create(:document) }
  end
end
