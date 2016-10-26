FactoryGirl.define do
  factory :tradeshift_key do
    key { Faker::Number.hexadecimal(10) }
    secret { Faker::Number.hexadecimal(10) }
    tenant_id { Faker::Number.hexadecimal(10) }
  end
end
