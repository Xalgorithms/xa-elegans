require 'rails_helper'

describe AssociationSerializer do
  it 'should serialize' do
    txm = create(:transaction)
    rand_array_of_models(:association, transact: txm).each do |am|
      ex = {
        id: am.public_id,
        rule: RuleSerializer.serialize(am.rule),
        transformation: TransformationSerializer.serialize(am.transformation),
        transaction: {
          id: am.transact.public_id,
        }
      }
      expect(AssociationSerializer.serialize(am)).to eql(ex)
      expect(AssociationSerializer.serialize(am, :transaction)).to eql(ex.except(:transaction))
    end
  end
end
