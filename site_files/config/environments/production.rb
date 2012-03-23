config.cache_classes = true

config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_controller.cache_store = :file_store, RAILS_ROOT+"/tmp/cache/"
config.action_view.cache_template_loading            = true

config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = YAML.load(File.open("#{RAILS_ROOT}/config/config.yml"))['production']['mailer']
config.action_mailer.raise_delivery_errors = true


