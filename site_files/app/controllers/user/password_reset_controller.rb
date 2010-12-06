class User::PasswordResetController < ApplicationController
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def new  
    render  
  end  
   
  def create  
    @user = User.find_by_email(params[:user_password_reset][:email])  
    if @user  
      @user.deliver_password_reset_instructions!  
      flash[:notice] = t('flash.password_resets_intruction_sent')
      redirect_to root_url  
    else  
      flash[:error] = t('flash.no_user_found_with_that_email')
      render :action => :new  
    end  
  end  

  def edit  
    @user.email = ""
    render  
  end  
   
  def update  
    @user.password = params[:user][:password]  
    @user.password_confirmation = params[:user][:password_confirmation]  
    if @user.email == params[:user][:email] && @user.save  
      flash[:notice] = t('flash.password_updated')
      redirect_to root_url  
    else  
      flash[:error] = t('flash.invalid_email_address')
      render :action => :edit  
    end  
  end  
      
  private  
    def load_user_using_perishable_token  
      @user = User.find_using_perishable_token(params[:id])  
      unless @user  
        flash[:error] = t('flash.user_resets_load_user_error')
        redirect_to root_url  
      end  
    end  
end
