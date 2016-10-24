class RuleSerializer < Serializer
  def self.serialize(rm, container=nil)
    {
      id:        rm.public_id,
      reference: rm.reference,
    }
  end
end
