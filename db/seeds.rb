# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

rules = ['cost-of-living', 'withholding', 'currency-conversion'].inject({}) do |rs, name|
  rs.merge(name => Rule.create(name: name))
end

if Rails.env.development?
  if !User.find_by(email: 'bob@nowhere.com')
    u = User.create(full_name: 'Bob Smith', email: 'bob@nowhere.com', password: 'password')
    acc = Account.create(name: 'All Rules', user: u, rules: rules.values)
    (0...10).each do |i|
      Account.create(name: "Other Account #{i}", user: u)
    end
  end
end
