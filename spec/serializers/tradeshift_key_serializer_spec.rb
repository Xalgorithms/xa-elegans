require 'rails_helper'

describe TradeshiftKeySerializer do
  it 'should serialize' do
    rand_array_of_models(:tradeshift_key).each do |tkm|
      ex = {
        key: tkm.key,
        secret: tkm.secret,
        tenant_id: tkm.tenant_id,
      }
      
      expect(TradeshiftKeySerializer.serialize(tkm)).to eql(ex)
    end
  end
end
