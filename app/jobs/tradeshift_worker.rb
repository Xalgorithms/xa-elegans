gem 'oauth'

class TradeshiftWorker
  include Sidekiq::Worker

  CONSUMER_KEY='OwnAccount' # Vendor id + random string (From App Developer (App->Tools->Tradeshift API Keys)
  CONSUMER_SECRET='OwnAccount' # Example secret (for the app to be authorized, from App Developer (App->Tools->Tradeshift API Keys))

  def perform
    Rails.logger.info('starting tradeshift worker')
    User.all.select { |um| um.tradeshift_key }.each(&method(:work_on_user))

    if Rails.env.production?
      Rails.logger.debug('scheduling next work')
      TradeshiftWorker.perform_in(1.hour)
    end
  end

  private

  def pull_from_tradeshift(tk)
    Rails.logger.info("pulling (tenant_id=#{tk.tenant_id})")
    consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET)
    token = OAuth::AccessToken.new(consumer, tk.key, tk.secret)

    Rails.logger.info('> requesting all documents')
    resp = token.get('https://api.tradeshift.com/tradeshift/rest/external/documents/', 'X-Tradeshift-TenantId' => tk.tenant_id, 'Accept' => 'application/json')
    Rails.logger.info("< #{resp.code}")
    
    o = MultiJson.decode(resp.body)
    documents = o.fetch('Document', []).map do |o|
      {
        id: o['DocumentId'],
        uri: o['URI'],
        type: o['DocumentType']['type'],
        last_edit: o['LastEdit'],
      }
    end.each do |o|
      Rails.logger.info("making document (public_id=#{o[:id]}; last_edit=#{o[:last_edit]})")
      dt = DateTime.parse(o[:last_edit])
      # zero out ms
      dt = dt.change(sec: dt.sec)
      dm = Document.find_by(public_id: o[:id])

      if dm
        Rails.logger.info("document exists (id=#{dm.id}, last_edit=#{o[:last_edit]}; last_sync=#{dm.tradeshift_sync_state.last_sync})")
        if dm.tradeshift_sync_state.last_sync < dt
          Rails.logger.info("document is updated")
          
          Rails.logger.info("> requesting document (id=#{o[:id]})")
          resp = token.get(o[:uri], 'X-Tradeshift-TenantId' => tk.tenant_id)
          Rails.logger.info("< #{resp.code}")

          dm.update_attributes(src: resp.body)
        else
          Rails.logger.info('document is up-to-date')
        end
      else
        Rails.logger.info("creating document")

        Rails.logger.info("> requesting document (id=#{o[:id]})")
        resp = token.get(o[:uri], 'X-Tradeshift-TenantId' => tk.tenant_id)
        Rails.logger.info("< #{resp.code}")

        yield(Document.create(public_id: o[:id], src: resp.body, tradeshift_sync_state: TradeshiftSyncState.create(last_sync: dt)))
      end
    end
  end
  
  def work_on_user(um)
    Rails.logger.info("syncing tradeshift (user=#{um.id})")
    pull_from_tradeshift(um.tradeshift_key) do |dm|
      Rails.logger.info('processing new documents')
      um.transactions.select { |trm| 'tradeshift' == trm.source }.each do |trm|
        InvoiceService.create_from_document(trm.id, dm.id)
      end
    end
  end
end
