FactoryGirl.define do
  factory :transformation_add_event do
    event { create(:event, event_type: 'transformation_add') }
    name  { Faker::Hacker.noun }
  end
end
