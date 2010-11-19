# Edit at your own peril - it's recommended to regenerate this file
# in the future when you upgrade to a newer version of Cucumber.

# IMPORTANT: Setting config.cache_classes to false is known to
# break Cucumber's use_transactional_fixtures method.
# For more information see https://rspec.lighthouseapp.com/projects/16211/tickets/165
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

unless File.directory?(File.join(Rails.root, 'vendor/plugins/cucumber'))
  config.gem "cucumber", :lib => false, :version => ">=0.6.2" 
end
unless File.directory?(File.join(Rails.root, 'vendor/plugins/webrat'))
  config.gem "webrat", :lib => false, :version => ">=0.7.0" 
end
unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec'))
  config.gem 'rspec', :lib => false, :version => '>=1.3.0'
end
unless File.directory?(File.join(Rails.root, 'vendor/plugins/rspec-rails'))
  config.gem 'rspec-rails', :lib => false, :version => '>=1.3.2' 
end
config.gem 'bmabey-email_spec',       :lib => 'email_spec'
config.gem "thoughtbot-factory_girl", :lib => "factory_girl", :source => "http://gems.github.com"
