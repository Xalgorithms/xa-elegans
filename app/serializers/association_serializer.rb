class AssociationSerializer < Serializer
  def self.serialize(am, container = nil)
    {
      id:             am.public_id,
      rule:           RuleSerializer.serialize(am.rule),
      transformation: TransformationSerializer.serialize(am.transformation),
    }.tap do |o|
      o[:transaction] = { id: am.transact.public_id } unless container == :transaction
    end
  end
end
