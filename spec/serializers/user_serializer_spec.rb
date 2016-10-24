require 'rails_helper'

describe UserSerializer do
  before(:each) do
    User.destroy_all
  end
  
  it 'should serialize' do
    rand_array_of_models(:user).each do |um|
      ex = {
        id: um.public_id,
        email: um.email,
      }
      
      expect(UserSerializer.serialize(um)).to eql(ex)
    end
  end

  it 'should serialize many' do
    ums = rand_array_of_models(:user)
    ex = ums.map(&UserSerializer.method(:serialize))
    expect(UserSerializer.many(ums)).to eql(ex)
  end
end
