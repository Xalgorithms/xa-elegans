require 'rails_helper'

describe Change, type: :model do
  it 'is associated with an invoice' do
    rand_array { create(:invoice) }.each do |inv|
      ch = create(:change, invoice: inv)
      expect(ch.invoice).to eql(inv)
    end
  end
end
