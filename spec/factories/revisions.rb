FactoryGirl.define do
  factory :revision do
    document { create(:document) }
  end
end
