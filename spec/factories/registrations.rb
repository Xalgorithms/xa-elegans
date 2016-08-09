FactoryGirl.define do
  factory :registration do
    token { Faker::Number.hexadecimal(100) }
  end
end
