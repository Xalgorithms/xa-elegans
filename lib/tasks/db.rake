require 'ubl/invoice'
require 'xa/transforms/parse'

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

  desc 'list all rules'
  task :list_rules, [] => :environment do |t, args|
    Rule.all.each do |rm|
      puts "id=#{rm.public_id}; reference=#{rm.reference}"
    end
  end

  desc 'list all users'
  task :list_users, [] => :environment do |t, args|
    User.all.each do |um|
      puts "id=#{um.public_id}; email=#{um.email}"
    end
  end
  
  desc 'list all transactions'
  task :list_transactions, [:user_id] => :environment do |t, args|
    um = User.where(public_id: args.user_id).first
    um.transactions.each do |trm|
      puts "id=#{trm.public_id}"
    end
  end
    
  
  desc 'update rule reference'
  task :update_rule_reference, [:rule_id, :rule_ref] => :environment do |t, args|
    rm = Rule.find_by(public_id: args.rule_id)
    rm.update_attributes(reference: args.rule_ref)
    rm.reload
    puts "id=#{rm.public_id}; reference=#{rm.reference}"
  end

  desc 'configure tradeshift'
  task :configure_tradeshift, [:user_id, :key, :secret, :tenant_id] => :environment do |t, args|
    um = User.find(args.user_id)
    um.update_attributes(tradeshift_key: TradeshiftKey.create(key: args.key, secret: args.secret, tenant_id: args.tenant_id))
  end

  class TransformParser
    include XA::Transforms::Parse
    
    def parse_content(content)
      parse(content.split(/\n/))
    end
  end

  def add_testing_transaction(user_id, transform_path, rule_ref, &bl)
    um = User.find(user_id)

    puts "> creating transaction structure (user=#{user_id})"
    txm = Transaction.create(public_id: UUID.generate, user: um, status: Transaction::STATUS_OPEN)
    puts "> created (transaction=#{txm.public_id})"

    name = File.basename(transform_path, '.transform')
    puts "> creating transformation (path=#{transform_path}; name=#{name})"
    src = File.read(transform_path)
    trm = Transformation.create(public_id: UUID.generate, name: name, src: src)
    trm.update_attributes(content: TransformParser.new.parse_content(src))
    puts "> created (transformation=#{trm.public_id})"

    puts "> association with transaction"
    rm = Rule.create(public_id: UUID.generate, reference: rule_ref)
    am = Association.create(transact: txm, rule: rm, transformation: trm)
    puts "> created (rule=#{rm.public_id}; association=#{am.id})"

    bl.call(txm) if bl
  end
  
  desc 'add testing transaction'
  task :add_transaction, [:user_id, :transform_path, :rule_ref] => :environment do |t, args|
    add_testing_transaction(args.user_id, args.transform_path, args.rule_ref)
  end
  
  desc 'add testing document'
  task :add_document, [:user_id, :path, :transform_path, :rule_ref] => :environment do |t, args|
    class InvoiceParser
      include UBL::Invoice
    end

    add_testing_transaction(args.user_id, args.transform_path, args.rule_ref) do |txm|
      puts "> creating invoice"
      im = Invoice.create(public_id: UUID.generate, transact: txm)

      puts "> creating document (path=#{args.path})"
      ubl = File.read(args.path)
      dm = Document.create(public_id: UUID.generate, src: ubl)
      puts "> created (document=#{dm.public_id})"

      puts "> parsing UBL"
      InvoiceParser.new.parse(ubl) do |content|
        dm.update_attributes(content: content)
        puts "> parsed"
      end

      puts "> attaching new revision to invoice"
      rm = Revision.create(invoice: im, document: dm)
      puts "> created (revision=#{rm.id})"
    end
  end

  desc 'clear all invoices and related documents associated w/a transaction'
  task :clear_all_invoices, [:transaction_public_id] => :environment do |t, args|
    txm = Transaction.where(public_id: args.transaction_public_id).first
    rvms = txm.invoices.inject([]) do |a, im|
      a + im.revisions.to_a
    end
    dms = rvms.map { |rvm| rvm.document }
    ims = rvms.map { |rvm| rvm.invoice }

    (rvms + dms + ims).each { |m| m.destroy }
  end
end
