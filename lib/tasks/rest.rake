namespace :rest do
  require 'faraday'
  require 'faraday_middleware'
  require 'json'

  DEFAULT_HOST = 'localhost:3000'
  HOSTS = {
    'staging' => 'geghard-staging.herokuapp.com',
  }
  def conn(host = DEFAULT_HOST)
    rhost = HOSTS.fetch(host, host)
    @conn ||= Faraday.new("http://#{rhost}") do |f|
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
  
  def post(rel, version, content, host = DEFAULT_HOST)
    puts "POST > #{rel}"
    resp = conn(host).post(make_url(rel, version), content)

    puts "POST < #{resp.status}"
    puts "# content=#{resp.body}"
  end

  def get(rel, version)
    puts "GET > #{rel}"
    resp = conn.get(make_url(rel, version))
    puts "GET < #{resp.status}"
    puts "# content=#{resp.body}"
  end
  
  def delete(rel, version, host = DEFAULT_HOST)
    puts "DELETE > #{rel}"
    resp = conn(host).delete(make_url(rel, version))
    puts "DELETE < #{resp.status}"
  end

  desc 'open a transaction via the REST API'
  task :transaction_open, [:user_id, :host] => :environment do |t, args|
    args.with_defaults(host: DEFAULT_HOST)
    if args.user_id
      puts "# posting transaction (user_id=#{args.user_id})"
      post("/users/#{args.user_id}/transactions", 1, { transaction: {} }, args.host)
    else
      puts '! user_id'
    end
  end

  desc 'close a transaction via the REST API'
  task :transaction_close, [:user_id, :transaction_id, :host] => :environment do |t, args|
    args.with_defaults(host: DEFAULT_HOST)
    if args.user_id && args.transaction_id
      puts "# posting transaction (user_id=#{args.user_id})"
      delete("/users/#{args.user_id}/transactions/#{args.transaction_id}", 1, args.host)
    else
      puts '! user_id'
    end
  end
end
