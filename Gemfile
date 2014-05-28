source "https://rubygems.org"

gem "rails", "4.1.0"

# Use PostgreSQL as the database for Active Record
gem "pg", :require => "pg"
gem "mysql2"
gem "sqlite3"

# Compressor of JavaScript assets
gem "uglifier", ">= 1.3.0"

# Use CoffeeScript for .js.coffee assets and views
gem "coffee-rails", "~> 4.0.0"

# Use jQuery as the JavaScript library
gem "jquery-rails"
#Uploading files via Ajax
gem 'jquery-fileupload-rails'

# User authentication
gem "devise", "3.2.4"

gem "omniauth-facebook"
gem "kaminari"
gem "ransack"
gem "dynamic_form"
gem 'mandrill-api'
# Keep in mind 
# https://github.com/ryanb/private_pub as a realtime chatting app
gem 'acts_as_commentable'
gem "twitter-bootstrap-rails"
gem "less-rails"
gem 'therubyracer' #dependancy for less-rails
gem 'carrierwave'
gem "fog"          # Support for Amazon s3
gem "rails_config" # Storing settings logic test/development/production
gem 'simple_form'

gem 'sidekiq'  #Background worker



group :test, :development do
  gem "rspec-rails"
  gem "debugger"
  gem "spork-rails"
  gem "awesome_print"
  gem "pry"
  gem "simplecov"
    gem "minitest"
end

group :development do
  gem "chronic"
  #gem "admin_view"
  gem 'better_errors'
  gem "binding_of_caller"
  gem 'rack-mini-profiler'
end

group :test do
  gem "factory_girl_rails"
  gem "cucumber-rails", :require => false
  gem "database_cleaner"
  gem "selenium-webdriver"
  gem "capybara"
  gem "shoulda"
  gem "email_spec"
  gem "capybara-webkit"
  gem "launchy"
  gem "webmock"
  gem "faker"
  gem 'fivemat'  #Beautiful test output
end

group :production, :development do
  gem "thin"
end
