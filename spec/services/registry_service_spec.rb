require 'rails_helper'

require 'xa/registry/client'

describe RegistryService do
  before(:each) do
    Rule.destroy_all
    SyncAttempt.destroy_all
  end
  
  it 'should sync rules from the Registry' do
    cl = double(XA::Registry::Client)
    rules = rand_array { "#{Faker::Hacker.noun}:#{Faker::Hacker.noun}:#{Faker::Number.number(4)}" }
    since = '1234'

    expect(XA::Registry::Client).to receive(:new).with(Settings::Defaults.registry.url).and_return(cl)
    expect(cl).to receive(:rules).and_return({ 'rules' => rules, 'since' => since})

    RegistryService.sync_rules

    expect(SyncAttempt.last.token).to eql(since)
    expect(Rule.all.map(&:reference)).to match_array(rules)
    expect(Rule.all.map(&:public_id).compact).to_not be_empty
  end

  it 'should send the last sync token' do
    cl = double(XA::Registry::Client)

    token = '1234'
    next_token = '3333'

    SyncAttempt.create(token: token)

    expect(XA::Registry::Client).to receive(:new).with(Settings::Defaults.registry.url).and_return(cl)
    expect(cl).to receive(:rules).with(token).and_return({ 'rules' => [], 'since' => next_token})

    RegistryService.sync_rules
    expect(SyncAttempt.last.token).to eql(next_token)
  end
end
