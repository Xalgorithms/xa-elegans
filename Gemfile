source 'https://rubygems.org'

ruby "2.2.4"

# basics
gem 'devise'
gem 'rails', '4.2.4'
gem "slim-rails", "~> 3.0"
gem 'turbolinks'

# JS related gems
gem 'jquery-rails'
gem 'js-routes'
gem 'lodash-rails'
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# style related gems
#gem 'bootstrap', '~> 4.0.0.alpha3'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'sass-rails', '>= 3.2'

# API stuff
gem 'jbuilder', '~> 2.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# libraries
gem 'faraday'
gem 'faraday_middleware'
gem 'nokogiri'
gem 'settingslogic'

# libs for UBL
gem 'countries'
gem 'currencies'
gem 'money'

gem 'mongo'

# deployment
gem 'dotenv-rails'
gem 'dotenv-heroku'

group :development, :test do
  gem 'sqlite3'

# Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # use a better repl
  gem 'pry-rails'

  # use a preferred appserver
  gem 'thin'

  # rspec tests
  gem "rspec-rails", "~> 3.0"

  gem 'awesome_print'
end

group :production, :staging do
  # use postgres in production
  gem 'pg'

  # Use Unicorn as the app server in production
  # gem 'unicorn'
  # heroku uses puma
  gem 'puma'

  gem 'rails_12factor'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

