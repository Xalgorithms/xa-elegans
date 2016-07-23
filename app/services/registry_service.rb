require 'xa/registry/client'

class RegistryService
  def self.sync_rules
    last_sync = SyncAttempt.last

    cl = XA::Registry::Client.new(ENV.fetch('XA_REGISTRY_URL', nil) || Settings::Defaults.registry.url)
    resp = last_sync ? cl.rules(last_sync.token) : cl.rules

    SyncAttempt.create(token: resp['since'])

    resp['rules'].map do |ref|
      Rule.create(reference: ref, public_id: UUID.generate)
    end
  end
end
