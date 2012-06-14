# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user, :logged_in?
  before_filter { |c| Authorization.current_user = c.current_user }
  before_filter :set_user_language
  before_filter :init if ENV['RAILS_ENV']=='development'
  
  helper_method :yt_client, :sc_client
  
  def yt_client
    @yt_client ||= YouTubeIt::Client.new(
      :username => "zamith.28@gmail.com" , 
      :password => "luispedro" , 
      :dev_key  => "AI39si7b-SojncB9QH2sLZGqe_s9jSdqoMFJNQ12HEYOUBelqqoomK3pqXxnmQrft8YTMiJnNE0UcOzx-04t8qUjm3yvYVedVg")
  end
  
  def sc_client
    if $SOUND_CLOUD_TOKEN
      @sc_client = Soundcloud.new({:access_token => $SOUND_CLOUD_TOKEN})
    else
      @sc_client = Soundcloud.new({
        :client_id      => "9726eb57e198e1e3b8edf2dbb0a038a5",
        :client_secret  => "0da72694fa5bdd47ac908c995e4f1970",
        :redirect_uri  => sound_cloud_index_url
      })
    end
  end

  $current_category = GlobalCategory.first

  # Used to show page rendering time
  def init
    @start_time = Time.now 
  end

  # Returns the current user session.
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  

  # Returns the current user, if there is a current user session.
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  # TO DELETE
  def logged_in?(role=nil)
    return !current_user.nil? unless role
    !current_user.nil? and current_user.is_role? role
  end

  private
    def self.any_as_privilege
      [:as_read, :as_create, :as_update, :as_delete]
    end
    
    def self.write_as_privilege
      [:as_create, :as_update, :as_delete]
    end

    # Stores current URI in session
    def store_location
      session[:return_to] = request.request_uri
    end

    # To use in before filter.
    # Asserts that there is not a current session.
    def require_no_user
      if current_user
        flash[:notice] = t 'flash.require_logout'
        redirect_to root_path
        return false
      else
        return true
      end
    end

    # To use in before filter.
    # Asserts that there is a current session.
    def require_user
      unless current_user
        store_location
        flash[:notice] = t 'flash.require_login'
        redirect_to new_user_session_url
        return false
      end
    end

    # Redirects to previous stored URI.
    # In case no of URI previous stored, redirects to given default.
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    # Sets the language for the current request.
    def set_user_language
      I18n.locale = session[:language] if !session[:language].nil? && !configatron.force_locale
      I18n.locale = configatron.default_locale
    end

end
