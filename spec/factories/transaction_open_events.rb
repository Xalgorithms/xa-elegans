FactoryGirl.define do
  factory :transaction_open_event do
    event { create(:event, event_type: 'transaction_open') }
  end
end
