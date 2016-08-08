namespace :rest do
  require 'faraday'
  require 'faraday_middleware'
  require 'json'

  DEFAULT_HOST = 'http://localhost:3000'
  HOSTS = {
    'staging' => 'https://xa-lichen.herokuapp.com',
  }
  def conn(host = DEFAULT_HOST)
    rhost = HOSTS.fetch(host, host)
    @conn ||= Faraday.new(rhost) do |f|
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

  def get(rel, version, host = DEFAULT_HOST)
    puts "GET > #{rel}"
    resp = conn(host).get(make_url(rel, version))
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
      puts "# posting event (user_id=#{args.user_id})"
      post("/events", 1, { event_type: 'transaction_open', transaction_open_event: { user_id: args.user_id } }, args.host)
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

  desc 'list transactions'
  task :transaction_list, [:user_id, :host] => :environment do |t, args|
    args.with_defaults(host: DEFAULT_HOST)
    if args.user_id
      get("/users/#{args.user_id}/transactions", 1, args.host)
    end
  end

  desc 'push an invoice to a transaction'
  task :invoice_push, [:transaction_id, :document_id, :host] => :environment do |t, args|
    args.with_defaults(host: DEFAULT_HOST)
    if args.transaction_id && args.document_id
      post("/events", 1, {
             event_type: 'invoice_push',
             invoice_push_event: {
               transaction_public_id: args.transaction_id,
               document_public_id: args.document_id,
             },
           }, args.host)
    end    
  end

  desc 'post a document'
  task :document_post, [:src, :host] => :environment do |t, args|
    args.with_defaults(host: DEFAULT_HOST)
    if args.src
      post('/documents', 1, IO.read(args.src), args.host)
    end
  end
end
