class TransformationSerializer
  def self.many(txms)
    MultiJson.encode(txms.map(&method(:serialize)))
  end

  def self.serialize(txm)
    {
      public_id: txm.public_id,
      name:      txm.name,
    }
  end
end
