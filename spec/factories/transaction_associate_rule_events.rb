FactoryGirl.define do
  factory :transaction_associate_rule_event do
    event { create(:event, event_type: 'transaction_associate_rule') }
    transact { create(:transaction) }
    rule { create(:rule) }
  end
end
