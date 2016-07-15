FactoryGirl.define do
  factory :rule do
    public_id { UUID.generate }
  end
end
