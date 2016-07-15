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

  desc 'add an account for a user'
  task :add_account, [:email, :name] => :environment do |t, args|
    
    if args.email && args.name
      u = User.find_by_email(args.email)
      if u
        acc = Account.create(name: args.name)
        u.accounts << acc
        puts "# account added"
      else
        puts "! failed to locate user (email=#{args.email})"        
      end
    else
      puts "! email and name are required"
    end
  end
end
