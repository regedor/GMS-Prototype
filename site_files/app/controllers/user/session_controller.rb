class User::SessionController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:destroy,:send_invitations, :show]
  
  def show
    @user = current_user
  end

  def language
    session[:language] = params[:language] if UserSession::LANGUAGES.map(&:last).include?(params[:language])
    redirect_to :back
  end
 
  def new
    @user_session = UserSession.new
  end
  
  def create
    if params[:user_session] && !params[:user_session][:openid_identifier].blank?
      @user_session = UserSession.new({:openid_identifier => params[:user_session][:openid_identifier]})
    else
      @user_session = UserSession.new(params[:user_session])
    end
    @user_session.save do |result|
      if result && UserSession.find.user.deleted?
        @user_session.destroy
        flash[:notice] = t('flash.login_failed')
        render :action => 'new'
      elsif result
        session[:language] = UserSession.find.user.language
        set_user_language
        flash[:notice] = t('flash.login')
        redirect_back_or_default root_url
      elsif request['openid.mode'] == 'id_res'
        flash[:notice] = t('flash.you_are_being_redirected')
        @user = User.new :openid_identifier => request['openid.identity']
        @auto_submit = true
        render :template => '/users/new'
        flash[:notice] = ""
      else 
        render :action => 'new'
      end
    end
  end
 
  def destroy
    current_user_session.destroy
    flash[:notice] = t 'flash.logout'
    redirect_back_or_default new_user_session_url
  end

  # POST
  def send_invitations
    @user = current_user 
    mails = params[:invitation][:emails].split ","
    mails.map! do |m| 
      m.strip!
      unless Authlogic::Regex.email.match(m)
        flash[:error] = t 'flash.invalid_user_invitations'
        redirect_to user_session_url
        return
      end
      m
    end
    mails.each { |m| @user.send_invitation!(m) }
    if mails.size == 1
      flash[:notice] = t 'flash.single_user_invitation', :mail => mails.first
    else
      flash[:notice] = t 'flash.multiple_user_invitations', :number => mails.size
    end
    redirect_to user_session_url
  end
end
