Webrat.configure do |config|
	config.mode = :selenium
	config.application_environment = :selenium
end

Cucumber::Rails::World.use_transactional_fixtures = false

require 'database_cleaner'

#clean database once whene starting
DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :truncation

Before do
	DatabaseCleaner.start
end 

After do
	DatabaseCleaner.clean
end
