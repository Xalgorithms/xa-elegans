FactoryGirl.define do
  factory :transaction do
    public_id { UUID.generate }
    user { create(:user) }
  end
end
