require 'faraday'
require 'faraday_middleware'
require 'multi_json'

class NotificationService
  class GcmClient
    def initialize
      @conn = Faraday.new('https://gcm-http.googleapis.com') do |f|
        f.request(:json)
        f.response(:json, :content_type => /\bjson$/)
#        f.response(:logger, Rails.logger, bodies: true)
        f.adapter(Faraday.default_adapter)
      end
      @conn.headers['Authorization'] = 'key=AIzaSyDAn5AaOp9pu3ss_5oUljHcmijtjFJwq9E'
    end

    def send(token, data)
      resp = @conn.post('/gcm/send', to: token, data: data)
      resp.success?
    end
  end
  
  def self.send(user_id, invoice_id, document_id)
    cl = GcmClient.new
    um = User.find(user_id)
    im = Invoce.find(invoice_id)
    dm = Document.find(document_id)
    um.registrations.each do |rm|
      Rails.logger.info("sending notification (to=#{rm.token}; document_id=#{dm.public_id}; invoice_id=#{im.public_id})")
      cl.send(rm.token, invoice_id: im.public_id, document_id: dm.public_id)
    end
  end
end
