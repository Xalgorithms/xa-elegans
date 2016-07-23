require 'rails_helper'

describe Api::V1::RulesController, type: :controller do
  include Randomness
  include ResponseJson
  
  it 'should show rules acquired from the Registry' do
    # assume some Rules exist
    rand_array_of_models(:rule)

    expect(RegistryService).to receive(:sync_rules)

    get(:index)

    expect(response).to be_success
    expect(response_json).to eql(Rule.all.map { |rm| rm.reference })
  end
end
