FactoryGirl.define do
  factory :invoice_push_event do
    event { create(:event, event_type: 'invoice_push') }
  end
end
