require 'rubygems'
require 'spork'

Spork.prefork do
  unless ENV['DRB']
    require 'simplecov'
    SimpleCov.start do
      add_filter '/spec/'
      add_filter '/config/'
      add_filter '/lib/'
      add_filter '/vendor/'
      add_group 'Controllers', 'app/controllers'
      add_group 'Models', 'app/models'
      add_group 'Helpers', 'app/helpers'
      add_group 'Mailers', 'app/mailers'
      add_group 'Views', 'app/views'
    end
  end
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'
  require "email_spec"
  require 'webmock/rspec'
  require 'rake'

  WebMock.disable_net_connect!(:allow_localhost => true)

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.include Devise::TestHelpers, :type => :controller

    config.extend ControllerMacros, :type => :controller
    config.extend FeatureMacros, :type => :feature

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    config.mock_with :rspec

    config.include(EmailSpec::Helpers)
    config.include(EmailSpec::Matchers)

    config.include FactoryGirl::Syntax::Methods

    config.before(:each) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

  end

end

Spork.each_run do
  if ENV['DRB']
    require 'simplecov'
    SimpleCov.start do
      add_filter '/spec/'
      add_filter '/config/'
      add_filter '/lib/'
      add_filter '/vendor/'
      add_group 'Controllers', 'app/controllers'
      add_group 'Models', 'app/models'
      add_group 'Helpers', 'app/helpers'
      add_group 'Mailers', 'app/mailers'
      add_group 'Views', 'app/views'
    end
  end
  load "#{Rails.root}/config/routes.rb"
  FactoryGirl.reload
end

