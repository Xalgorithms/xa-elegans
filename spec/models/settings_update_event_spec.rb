require 'rails_helper'

describe SettingsUpdateEvent, type: :model do
  include Randomness

  it 'should associate with users' do
    rand_array_of_models(:user).each do |um|
      em = SettingsUpdateEvent.create(user: um)
      expect(em.user).to eql(um)
      em.reload
      expect(em.user).to eql(um)
    end
  end

  it 'should associate with events' do
    rand_array_of_models(:event).each do |em|
      sem = SettingsUpdateEvent.create(event: em)
      expect(sem.event).to eql(em)
      sem.reload
      expect(sem.event).to eql(em)
    end
  end
end
