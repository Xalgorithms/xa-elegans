FactoryGirl.define do
  factory :rule do
    public_id { UUID.generate }
    version { Faker::Number.hexadecimal(6) }
  end
end
