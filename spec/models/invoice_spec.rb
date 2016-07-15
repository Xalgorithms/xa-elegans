require 'rails_helper'

describe Invoice, type: :model do
  it 'is associated with changes' do
    rand_times.each do
      changes = rand_array { create(:change) }
      inv = create(:invoice, applied_changes: changes)
      expect(inv.applied_changes.to_a).to eql(changes)
    end
  end
end
