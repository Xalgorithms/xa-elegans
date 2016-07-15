# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

fuel = {
  'bob@nowhere.com' => {
    :full_name   => 'Bob Smith',
    :password    => 'password',
  },
}

fuel.each do |email, user_props|
  unless User.find_by(email: email)
    u = User.create(user_props.except(:accounts).merge(email: email))
  end
end
