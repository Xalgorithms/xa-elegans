class RuleSerializer
  def self.many(rms)
    rms.map(&method(:serialize))
  end

  def self.serialize(rm)
    {
      id:        rm.public_id,
      reference: rm.reference,
    }
  end
end
