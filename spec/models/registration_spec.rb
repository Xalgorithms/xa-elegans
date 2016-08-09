require 'rails_helper'

describe Registration, type: :model do
  include Randomness

  before(:each) do
    Registration.destroy_all
    User.destroy_all
  end

  it 'has one user' do
    rand_array_of_models(:user).each do |um|
      rm = create(:registration, user: um)
      expect(rm.user).to eql(um)
    end
  end
end
