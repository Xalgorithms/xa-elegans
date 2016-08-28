require 'rails_helper'

describe ExecuteService do
  after(:all) do
    Association.destroy_all
    Invoice.destroy_all
    Rule.destroy_all
    Transformation.destroy_all
  end
  
  it 'should execute transactions' do
    rand_array_of_models(:transaction).each do |txm|
      ams = rand_array_of_models(:association, transact: txm).map do |am|
        am.update_attributes(rule: create(:rule), transformation: create(:transformation))
        am
      end

      ims = rand_array_of_models(:invoice, transact: txm)

      ams.each do |am|
        ims.each do |im|
          expect(InterpretService).to receive(:execute).with(im.id, am.rule.id, am.transformation.id)
        end
      end

      ExecuteService.execute(txm.id)
    end
  end
end
