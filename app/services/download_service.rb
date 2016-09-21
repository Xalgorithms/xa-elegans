require 'faraday'
require 'faraday_middleware'

class DownloadService
  def self.get(url, &bl)
    conn = Faraday.new do |f|
      f.adapter(Faraday.default_adapter)        
    end
    resp = conn.get(url)
    bl && resp.success? ? bl.call(resp.body) : resp.body
  end
end
