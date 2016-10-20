require 'rails_helper'

describe TradeshiftSyncState, type: :model do
  include Randomness

  before(:all) do
    Document.destroy_all
    TradeshiftSyncState.destroy_all
  end

  it 'belongs to a document' do
    rand_array_of_models(:document).each do |dm|
      ssm = create(:tradeshift_sync_state, document: dm)
      expect(ssm.document).to eql(dm)
      expect(TradeshiftSyncState.find(ssm.id).document).to eql(dm)
    end
  end
end
