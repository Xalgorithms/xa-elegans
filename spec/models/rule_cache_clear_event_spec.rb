require 'rails_helper'

describe RuleCacheClearEvent, type: :model do
  include Randomness

  it 'should associate with events' do
    rand_array_of_models(:event).each do |em|
      rem = RuleCacheClearEvent.create(event: em)
      expect(rem.event).to eql(em)
      rem.reload
      expect(rem.event).to eql(em)

      em.reload
      expect(em.rule_cache_clear_event).to eql(rem)
    end
  end
end
