# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_user_session, :current_user, :logged_in?
  filter_parameter_logging :password, :password_confirmation
  before_filter :set_user_language

  private
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

    # Returns true there is a current user with a given role.
    # Only checks for a current user if no role is given.
    # Role is a symbol.
    def logged_in?(role=nil)
      return !current_user.nil? unless role
      !current_user.nil? and current_user.is_role? role
    end

    # To use in before filter.
    # Asserts that there is not a current session.
    def require_no_user
      if current_user
        store_location
        flash[:notice] = t 'flash.require_logout'
        redirect_to page_url(:root_page)
        return false
      end
    end

    # To use in before filter.
    # Asserts that there is a current session and user is not deleted.
    # If the current user is deleted, user session is destroyed.
    def require_user
      if !current_user.nil? and current_user.deleted?
        current_user_session.destroy
      end
      unless current_user
        store_location
        flash[:notice] = t 'flash.require_login' 
        redirect_to new_user_session_url
        return false
      end
    end

    # To use in before filter.
    # Asserts that there is a current user with admin role and its not deleted.
    # If the current user is deleted, user session is destroyed.
    def require_admin
      if !current_user.nil? and current_user.deleted?
        current_user_session.destroy
      end
      unless current_user and current_user.is_role? :admin
        store_location
        flash[:notice] = t 'flash.you_need_admin_login' 
        redirect_to login_url
        return false
      end
    end 
    
    # Stores current URI in session
    def store_location
      session[:return_to] = request.request_uri
    end
    
    # Redirects to previous stored URI.
    # In case no of URI previous stored, redirects to given default.
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    # Sets the language for the current request.
    def set_user_language
      I18n.locale = session[:language] unless session[:language].nil?
    end
end
