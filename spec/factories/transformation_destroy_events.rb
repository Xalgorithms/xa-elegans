FactoryGirl.define do
  factory :transformation_destroy_event do
    event { create(:event, event_type: 'transformation_destroy') }
    public_id { UUID.generate }
  end
end
