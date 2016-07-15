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

    def make_url(rel, version)
      "/api/v#{version}#{rel}"
    end
    
    def post(rel, version, content)
      puts "POST > #{rel}"
      resp = conn.post(make_url(rel, version), content)

      puts "POST < #{resp.status}"
      puts "# content=#{resp.body}"
    end

    def get(rel, version)
      puts "GET > #{rel}"
      resp = conn.get(make_url(rel, version))
      puts "GET < #{resp.status}"
      puts "# content=#{resp.body}"
    end
    
    def delete(rel, version)
      puts "DELETE > #{rel}"
      resp = conn.delete(make_url(rel, version))
      puts "DELETE < #{resp.status}"
    end

    desc 'open a transaction via the REST API'
    task :transaction_open, [:user_id] => :environment do |t, args|
      if args.user_id
        puts "# posting transaction (user_id=#{args.user_id})"
        post("/users/#{args.user_id}/transactions", 1, transaction: {})
      else
        puts '! user_id'
      end
    end

    desc 'close a transaction via the REST API'
    task :transaction_close, [:user_id, :transaction_id] => :environment do |t, args|
      if args.user_id && args.transaction_id
        puts "# posting transaction (user_id=#{args.user_id})"
        delete("/users/#{args.user_id}/transactions/#{args.transaction_id}", 1)
      else
        puts '! user_id'
      end
    end

    # old. might not work.
    
    desc 'post a new invoice'
    task :invoice_add, [:account_id, :effective] => :environment do |t, args|
      args.with_defaults(effective: Time.now.to_date.to_s)
      if args.account_id
        puts "# posting invoice (account=#{args.account_id}; effective=#{args.effective})"
        post("/accounts/#{args.account_id}/invoices", 1, invoice: { effective: args.effective })
      else
        puts '! account id is required'
      end
    end
    
    desc 'delete an invoice'
    task :invoice_rm, [:invoice_id] => :environment do |t, args|
      if args.invoice_id
        delete("/invoices/#{args.invoice_id}", 1)        
      else
        puts '! invoice_id required'
      end
    end

    desc 'get an invoice'
    task :invoice_get, [:invoice_id] => :environment do |t, args|
      if args.invoice_id
        get("/invoices/#{args.invoice_id}", 1)        
      else
        puts '! invoice_id required'
      end
    end

    desc 'get all invoices for an account'
    task :invoices, [:account_id] => :environment do |t, args|
      if args.account_id
        get("/accounts/#{args.account_id}/invoices", 1)
      else
        puts '! account_id required'
      end
    end

    desc 'get an account'
    task :account_get, [:account_id] => :environment do |t, args|
      if args.account_id
        get("/accounts/#{args.account_id}", 1)
      else
        puts '! account_id required'
      end
    end
    
    desc 'disassociate an account rule'
    task :rule_disassociate, [:account_id, :rule_id] => :environment do |t, args|
      if args.account_id && args.rule_id
        delete("/accounts/#{args.account_id}/rules/#{args.rule_id}", 1)
      else
        puts '! account_id and rule_id required'
      end
    end
  end
end
