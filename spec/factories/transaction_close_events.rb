FactoryGirl.define do
  factory :transaction_close_event do
    event { create(:event, event_type: 'transaction_close') }
  end
end
