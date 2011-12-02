ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'test_help'
require 'nokogiri'
require 'shoulda'
require 'database_cleaner'
require 'factory_girl'
require 'capybara/rails'
require 'capybara'
require 'capybara/dsl'
require 'capybara/session'

#DatabaseCleaner.strategy = :truncation
#DatabaseCleaner.clean

Capybara.default_driver = :selenium
Capybara.default_selector = :css
Capybara.default_wait_time = 30

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  self.use_transactional_fixtures = false
  self.use_instantiated_fixtures  = false

  # Add more helper methods to be used by all tests here...
  #def render(args);  get :_renderizer, :args => args;  end
  
end

