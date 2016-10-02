source 'https://rubygems.org'

ruby "2.3.1"

# basics
gem 'active_model_serializers'
gem 'rails-observers'
gem 'devise'
gem 'rails', '4.2.4'
gem "slim-rails", "~> 3.0"
gem 'turbolinks'

# JS related gems
gem 'jquery-rails'
gem 'js-routes', git: 'https://github.com/railsware/js-routes.git'
gem 'lodash-rails'
gem 'knockoutjs-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# style related gems
#gem 'bootstrap', '~> 4.0.0.alpha3'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'sass-rails', '>= 3.2'
gem 'font-awesome-rails'

# API stuff
gem 'jbuilder', '~> 2.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# libraries
gem 'awesome_print'
gem 'faraday'
gem 'faraday_middleware'
gem 'liquid'
gem 'nokogiri'
gem 'settingslogic'
gem 'uuid'

# libs for UBL
gem 'countries'
gem 'currencies'
gem 'eu_central_bank', git: 'https://github.com/RubyMoney/eu_central_bank.git'
gem 'money'

# deployment
gem 'dotenv-rails'
gem 'dotenv-heroku'

# ours
gem 'xa-rules', git: 'https://github.com/Xalgorithms/xa-rules.git'

group :development, :test do
  gem 'byebug'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'faker'
  gem "rspec-rails"
  gem 'sqlite3'
  gem 'fuubar'
end

group :production, :staging do
  gem 'pg'
  gem 'puma'
  gem 'rails_12factor'
end

group :development do
  # use a better repl
  gem 'pry-rails'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # use a preferred appserver
  gem 'thin'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

