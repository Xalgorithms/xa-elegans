FactoryGirl.define do
  factory :event do
    public_id { UUID.generate }
  end
end
