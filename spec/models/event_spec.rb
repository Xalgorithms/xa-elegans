require 'rails_helper'

describe Event, type: :model do
  include Randomness

  it 'should auto-assign a public id' do
    id = UUID.generate
    em = create(:event, public_id: id)
    expect(em.public_id).to eql(id)

    em = create(:event)
    expect(em.public_id).to_not be_nil
  end
  
  it 'should associate with a settings update event' do
    rand_array_of_models(:event).each do |em|
      sem = SettingsUpdateEvent.create(event: em)
      em.reload
      expect(em.settings_update_event).to eql(sem)
    end
  end
end
