FactoryGirl.define do
  factory :transformation do
    name { Faker::Hacker.noun }
    public_id { UUID.generate }
  end
end
