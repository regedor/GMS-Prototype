ENV["RAILS_ENV"] ||= "test" 

require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
require 'cucumber/rails/rspec'
require 'cucumber/rails/world'
require 'cucumber/rails/active_record'
require 'cucumber/web/tableish'
#require 'email_spec/cucumber'
require 'capybara/rails'
require 'capybara/cucumber'
require 'capybara/session'
require 'cucumber/rails/capybara_javascript_emulation' # Lets you click links with onclick javascript handlers without using @culerity or @javascript
require 'factory_girl'
require 'database_cleaner'

require File.expand_path(File.dirname(__FILE__) + '/../../test/factories.rb')

Capybara.default_selector = :css
Capybara.default_driver = :selenium
ActionController::Base.allow_rescue = false

Cucumber::Rails::World.use_transactional_fixtures = true
if defined?(ActiveRecord::Base)
  begin
    require 'database_cleaner'
    DatabaseCleaner.strategy = :truncation
  rescue LoadError => ignore_if_database_cleaner_not_present
  end
end

DatabaseCleaner.strategy = :truncation
if defined?(ActiveRecord::Base)
  begin
    require 'database_cleaner'
    DatabaseCleaner.strategy = :truncation
  rescue LoadError => ignore_if_database_cleaner_not_present
  end
end

ActionController::Base.allow_rescue = false

# Beware that turning transactions off will leave data in your database 
# after each scenario, which can lead to hard-to-debug failures in 
# subsequent scenarios. If you do this, we recommend you create a Before
# block that will explicitly put your database in a known state.
#Cucumber::Rails::World.use_transactional_fixtures = true
