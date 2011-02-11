class User::AccountController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :activate]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def index
    @users = User.all
  end  
  
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
    @user = params[:id].nil? ? current_user : User.find(params[:id])
  end
 
  def edit
    @user = current_user
    @picks = UserOptionalGroupPick.for_user_with_selected(@user)
  end
  
  def update
    @user = current_user
    #FIXME: Improve the following choosable groups validations (these validations are only needed in the frontend)
    if params[:user][:choosable_group_ids]
      params[:user][:choosable_group_ids].each do |id|
        next if (id == "") || Group.find(id).user_choosable
        # Only a malicious user reaches here
        head 500
        return
      end
    end
    if params[:user][:user_optional_group_picks]
      params[:user][:user_optional_group_picks].each do |pick_id, group_id|
        next if UserOptionalGroupPick.find(pick_id).groups.map(&:id).member? group_id.to_i
        # Only a malicious user reaches here
        head 500
        return
      end
    end

    initial_group_ids = @user.group_ids.dup
    group_ids = @user.group_ids.dup - Group.all(:conditions => { :user_choosable => true }).map(&:id)
    group_ids |= (params[:user][:choosable_group_ids] - [""]).map(&:to_i) if params[:user][:choosable_group_ids]
    if params[:user][:user_optional_group_picks]
      params[:user][:user_optional_group_picks].each do |pick_id, group_id|
        group_ids << group_id.to_i
      end
    end
    @user.group_ids = group_ids.uniq

    @user.attributes = params[:user]
    @user.save do |result|
      if result
        if (validation_errors = @user.validate_group_picks).empty?
          session[:language] = @user.language
          flash[:notice] = t('flash.account_updated')
          redirect_to user_account_path(@user)
        else
          # Groups are an association, therefore they are always saved
          # This reverts the groups to the initial state, in case something is not validated
          @user.group_ids = initial_group_ids
          flash[:error] = t('users.errors.user_optional_group_picks.generic') + ":<br />" + validation_errors.map(&:to_s).join('<br />')
          redirect_to :action => 'edit'
        end
      else
        flash[:error] = t('users.errors.invalid_fields') + ":<br />" + @user.errors.each { |i,e| e.to_s}.join(', ')
        redirect_to :action => 'edit'
      end
    end
    session[:language] = @user.language
  end
end
