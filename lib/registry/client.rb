module Registry
  # this came from xa-repository.simple it should be factored into a
  # gem that can be shared
  class Client
    def initialize
      @conn = Faraday.new(registry_url) do |f|
        f.request(:url_encoded)
        f.request(:json)
        f.response(:json, :content_type => /\bjson$/)
        f.adapter(Faraday.default_adapter)        
      end
    end

    def registry_url
      ENV.fetch('XA_REGISTRY_URL', 'http://localhost:3000')
    end
    
    def update_rule(name, version, repo_id)
      puts "> PUT /api/v1/rules/#{name}/#{version}"
      resp = @conn.put("/api/v1/rules/#{name}", rule: { version: version, repository: { id: repo_id } })
      puts "< #{resp.status}"
      if resp.success?
        yield(resp.body.fetch('public_id'))
      end
    end

    def register(url)
      puts "> POST /api/v1/repositories"
      resp = @conn.post('/api/v1/repositories', repository: { url: url })
      puts "< #{resp.status}"
      if resp.success?
        yield(resp.body.fetch('public_id'))
      end
    end

    def rules(&bl)
      get('/api/v1/rules') do |rules|
        bl.call(rules) if bl
      end
    end

    def rule(id, version, &bl)
      get("/api/v1/rules/#{id}/#{version}/content") do |rule|
        bl.call(rule) if bl
      end
    end
    
    private
    
    def get(relative_url, &bl)
      logger.info("> GET #{relative_url}")
      resp = @conn.get(relative_url)
      logger.info("< #{resp.status}")
      if resp.success?
        bl.call(resp.body) if bl
        resp.body
      else
        nil
      end
    end

    def logger
      Rails.logger
    end
  end
end
