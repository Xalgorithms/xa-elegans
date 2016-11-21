FactoryGirl.define do
  factory :association do
    rule { create(:rule) }
    transformation { create(:transformation) }
  end
end
