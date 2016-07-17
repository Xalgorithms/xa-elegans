FactoryGirl.define do
  factory :invoice do
    public_id { UUID.generate }
  end
end
