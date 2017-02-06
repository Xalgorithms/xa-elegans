require 'xa/registry/client'

class RegistryService
  def self.sync_rules
    last_sync = SyncAttempt.last

    begin
      cl = XA::Registry::Client.new(ENV.fetch('XA_REGISTRY_URL', nil) || Settings::Defaults.registry.url)

      # get existing
      refs = Set.new(Rule.all.map(&:reference))
      resp = last_sync ? cl.rules(last_sync.token) : cl.rules
      
      SyncAttempt.create(token: resp['since'])
      
      resp['rules'].select { |ref| !refs.include?(ref) }.map do |ref|
        Rule.create(reference: ref, public_id: UUID.generate)
      end
    rescue
      Rails.logger.error("TODO_fix: failed to create client")
    end

  end
end
