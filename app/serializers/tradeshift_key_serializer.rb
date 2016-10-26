class TradeshiftKeySerializer < Serializer
  def self.serialize(tkm, container=nil)
    {
      key: tkm.key,
      secret: tkm.secret,
      tenant_id: tkm.tenant_id,
    }
  end
end
