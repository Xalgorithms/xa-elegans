# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

{
  'cost-of-living'      => ['from', 'to'],
  'witholding'         => ['percentage'],
  'currency-conversion' => ['from', 'to'],
}.inject({}) do |o, kv|
  parameters = kv.last.map { |n| Parameter.create(name: n) }
  o.merge(kv.first => Rule.create(name: kv.first, parameters: parameters))
end
  
fuel = {
  'bob@nowhere.com' => {
    :full_name   => 'Bob Smith',
    :password    => 'password',
    :accounts    => {
      'Transfer to Yerevan' => [
        {
          :rule       => 'cost-of-living',
          :assignments => {
            'from' => '{ "city" : "Ottawa", "country" : "Canada" }',
            'to'   => '{ "city" : "Yerevan", "country" : "Armenia" }',
          },
        },
        {
          :rule       => 'currency-conversion',
          :assignments => {
            'from' => '{ "code" : "CAN" }',
            'to'   => '{ "code" : "ARM" }',
          },
        },
      ],
      'Take some tax' => [
        {
          :rule       => 'witholding',
          :assignments => {
            'percentage' => '34',
          },
        }
      ]
    },
  },
}

fuel.each do |email, user_props|
  if !User.find_by(email: email)
    u = User.create(user_props.except(:accounts).merge(email: email))
    user_props[:accounts].each do |name, invocations_props|
      invocations = invocations_props.map do |invocation_props|
        rule = Rule.find_by(name: invocation_props[:rule])
        assignments = invocation_props[:assignments].map do |name, actual|
          param = rule.parameters.where(name: name).first
          Assignment.create(actual: actual, parameter: param)
        end
        Invocation.create(rule: rule, assignments: assignments)
      end
      Account.create(name: name, user: u, invocations: invocations)
    end
  end
end
