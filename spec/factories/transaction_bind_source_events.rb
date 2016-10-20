FactoryGirl.define do
  factory :transaction_bind_source_event do
    event { create(:event, event_type: 'transaction_bind_source') }
    transact { create(:transaction) }
  end
end
