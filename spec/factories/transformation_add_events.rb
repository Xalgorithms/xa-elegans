FactoryGirl.define do
  factory :transformation_add_event do
    event { create(:event, event_type: 'transformation_add') }
    transformation { create(:transformation) }
  end
end
