# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  config.gem "formtastic"
  config.gem "authlogic"
  config.gem "authlogic-oid", :lib => "authlogic_openid"
  config.gem "ruby-openid",   :lib => "openid"
  config.gem "configatron"
  config.gem "will_paginate"
  config.gem "declarative_authorization", :source => "http://gemcutter.org"
  config.gem "chronic"
  config.gem "coderay"
  config.gem "lesstile"
  config.gem "calendar_date_select"
  config.gem "post_commit"
  config.gem "paperclip"
  config.gem "sparklines"


  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  # This is not the only place that you have to change the host
  config.action_mailer.default_url_options = { :host => 'www.regedor.com' }
end

configatron.configure_from_yaml("config/config.yml", :hash => Rails.env)

begin; Setting.load_settings_to_configatron; rescue Exception; end

require 'string_extensions'
require 'formtastic_extensions'
require 'sparklines'

=begin
module I18n

  def self.t(label, options = {})
    "pumba"
  end

  def self.translate(label, options = {})
    "pumba"
  end

end
=end

