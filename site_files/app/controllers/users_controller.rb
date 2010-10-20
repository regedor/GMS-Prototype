class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :activate]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.save do | result | 
      if result 
        session[:language] = @user.language
        if request["openid.op_endpoint"] == "https://www.google.com/accounts/o8/ud"
          @user.activate!
          @user.deliver_activation_confirmation!
          UserSession.new(@user,true).save
          flash[:notice] = t 'flash.login'
          redirect_back_or_default root_url
        else
          @user.deliver_activation_instructions!
          flash[:notice] = t('flash.account_created') 
          redirect_to root_url
        end
      else
        flash[:error] = @user.errors[:base] 
        render :action => :new
      end
    end
  end
  
  def activate
    @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @user.active?
    session[:language] = @user.language
    if @user.activate!
      @user.deliver_activation_confirmation!
      flash[:notice] = t('flash.account_activated') 
      redirect_to new_user_session_path
    else
      render :action => :new
    end
  end

  def show
    @user = current_user
  end
 
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    @user.attributes = params[:user]
    @user.save do |result|
      if result
        session[:language] = @user.language
        flash[:notice] = t('flash.account_updated')
        redirect_to account_url
      else
        render :action => 'edit'
      end
    end
    session[:language] = @user.language
  end
end
