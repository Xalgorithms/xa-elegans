FactoryGirl.define do
  factory :invoice do
    public_id { UUID.generate }
    document  { create(:document) }
  end
end
