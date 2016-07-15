# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  u = User.create(full_name: 'Test User', email: 'foo@nowhere.com', password: 'password')
  (0...10).each do |i|
    Account.create(name: "Account #{i}", user: u)
  end
end
