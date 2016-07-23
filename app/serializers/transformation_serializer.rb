class TransformationSerializer
  def self.many(txms)
    txms.map(&method(:serialize))
  end

  def self.serialize(txm)
    {
      id:   txm.public_id,
      name: txm.name,
    }
  end
end
