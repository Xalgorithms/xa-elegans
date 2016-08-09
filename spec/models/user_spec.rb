require 'rails_helper'

describe User, type: :model do
  include Randomness

  before(:each) do
    Registration.destroy_all
    User.destroy_all
  end

  it 'has many registrations' do
    rand_array_of_models(:user).each do |um|
      rms = rand_array_of_models(:registration, user: um)
      expect(um.registrations).to match_array(rms)
    end
  end
end
