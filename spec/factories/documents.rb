FactoryGirl.define do
  factory :document do
    public_id { UUID.generate }
  end
end
