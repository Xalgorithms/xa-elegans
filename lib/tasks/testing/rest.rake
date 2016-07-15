namespace :testing do
  namespace :rest do
    require 'faraday'
    require 'faraday_middleware'
    require 'json'
    
    def conn
      @conn ||= Faraday.new('http://localhost:3000') do |f|
        f.request(:url_encoded)
        f.request(:json)
        f.response(:json, :content_type => /\bjson$/)
        f.adapter(Faraday.default_adapter)
        # f.token_auth(@key)
      end
    end

    def post(rel, version, content)
      puts "POST > #{rel}"
      resp = conn.post do |req|
        req.url("/api#{rel}")
        req.headers['Accept'] = "application/json; version=#{version}"
        req.body = content
      end

      puts "POST < #{resp.status}"
      puts "# content=#{resp.body}"
    end
    
    desc 'post a new invoce'
    task :invoice, [:account_id, :effective] => :environment do |t, args|
      args.with_defaults(effective: Time.now.to_date.to_s)
      if args.account_id
        puts "# posting invoice (account=#{args.account_id}; effective=#{args.effective})"
        post("/accounts/#{args.account_id}/invoices", 1, invoice: { effective: args.effective })
      else
        puts '! account id is required'
      end
    end
  end
end
