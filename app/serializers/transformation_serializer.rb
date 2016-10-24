class TransformationSerializer < Serializer
  def self.serialize(txm, container=nil)
    {
      id:   txm.public_id,
      name: txm.name,
    }
  end
end
