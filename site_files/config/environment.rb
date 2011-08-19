RAILS_GEM_VERSION = '2.3.8'
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  yaml_config = YAML.load(File.open("#{RAILS_ROOT}/config/config.yml"))[ENV["RAILS_ENV"]||'development']

  config.time_zone                         = 'UTC'
  config.i18n.default_locale               = yaml_config['default_locale']
  config.action_mailer.default_url_options = { :host => yaml_config['site_domain'] }
end

begin; Setting.load_settings_to_configatron; rescue Exception; end

Clickatell::API.debug_mode                 = false

if ENV['I18N_MOCK']
  module I18n
    def self.t(label, options = {}) ; ENV['I18N_MOCK'] ; end
    def self.translate(label, options = {}) ; ENV['I18N_MOCK'] ; end
  end
end

