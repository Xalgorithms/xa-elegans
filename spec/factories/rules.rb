FactoryGirl.define do
  factory :rule do
    reference { "#{Faker::Hacker.noun}:#{Faker::Hacker.noun}:#{Faker::Number.number(4)}" }
    public_id { UUID.generate }
  end
end
