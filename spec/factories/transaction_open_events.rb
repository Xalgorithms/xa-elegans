FactoryGirl.define do
  factory :transaction_open_event do
    event { create(:event) }
  end
end
