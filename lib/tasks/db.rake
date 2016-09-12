require 'ubl/invoice'

namespace :db do
  desc "add a new user"
  task :add_user, [:email, :password, :fullname] => :environment do |t, args|
    args.with_defaults(fullname: args.email)
    
    if args.email && args.password
      u = User.find_by_email(args.email)
      if u.nil?
        puts "# creating user (email=#{args.email})"
        User.create(email: args.email, full_name: args.fullname, password: args.password)
      else
        puts "# user exists (email=#{args.email})"
      end
    else
      puts "! email and password are required"
    end
  end

  desc 'add testing document'
  task :add_document, [:user_id, :path] => :environment do |t, args|
    include UBL::Invoice    

    um = User.find(args.user_id)
    puts "> creating transaction structure (user=#{args.user_id})"
    txm = Transaction.create(public_id: UUID.generate, user: um, status: Transaction::STATUS_OPEN)
    im = Invoice.create(public_id: UUID.generate, transact: txm)

    puts "> created (transaction=#{txm.public_id}; invoice=#{im.public_id}"
    
    puts "> creating document (path=#{args.path})"
    ubl = File.read(args.path)
    dm = Document.create(public_id: UUID.generate, src: ubl)
    puts "> created (document=#{dm.public_id})"

    puts "> parsing UBL"
    parse(ubl) do |content|
      dm.update_attributes(content: content)
      puts "> parsed"
    end

    puts "> attaching new revision to invoice"
    rm = Revision.create(invoice: im, document: dm)
    puts "> created (revision=#{rm.id})"
  end
end
