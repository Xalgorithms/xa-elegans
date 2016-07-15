namespace :testing do
  namespace :db do
    desc 'seed testing data'
    task :seed, [] => :environment do |t, args|
      u = User.create(full_name: 'Test User', email: 'foo@nowhere.com', password: 'password')
      (0...10).each do |i|
        Account.create(name: "Account #{i}", user: u)
      end
    end
  end
end
