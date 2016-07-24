class AssociationSerializer
  def self.many(ams, container = nil)
    ams.map(&method(:serialize))
  end

  def self.serialize(am, container = nil)
    {
      rule:           RuleSerializer.serialize(am.rule),
      transformation: TransformationSerializer.serialize(am.transformation),
    }.tap do |o|
      o[:transaction] = { id: am.transact.public_id } unless container == :transaction
    end
  end
end
