config.cache_classes                                 = true
config.whiny_nils                                    = true
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_controller.allow_forgery_protection    = false
config.action_mailer.delivery_method                 = :test




# hack to handle keeping of flash messages after redirect
class RackRailsCookieHeaderHack
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    if headers['Set-Cookie'] && headers['Set-Cookie'].respond_to?(:collect!)
      headers['Set-Cookie'].collect! { |h| h.strip }
    end
    [status, headers, body]
  end
end

config.after_initialize { ActionController::Dispatcher.middleware.insert_before(ActionController::Base.session_store, RackRailsCookieHeaderHack) }
