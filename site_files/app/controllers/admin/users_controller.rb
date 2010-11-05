class Admin::UsersController < Admin::BaseController
  active_scaffold :user do |config|
    config.actions.swap :search, :live_search
    config.actions.exclude :update, :delete, :show, :create

    config.actions << :show
    config.actions << :update
    config.actions << :delete
    
    config.row_mark_actions_list = [:destroy, :activate!]
    
    config.subform.columns.exclude :email, :active, :password, :nickname, :profile, :website,
     :language, :country, :gender, :role, :phone, :crypted_password, :current_login_at, :last_login_at, :current_login_ip, :last_login_ip,
     :persistence_token, :single_access_token, :perishable_token, :openid_identifier, :password_salt, :last_request_at

    Scaffoldapp::active_scaffold config, "admin.users", [
      :created_at, :email, :active, :language, :name, :role
    ], true
  end
  
  
  def active
   flash[:notice] = "works"
   respond_to do |format|
     format.html { redirect_to :action=>"" }
     format.js
   end
    #redirect_to root_path 
    return true
  end
  
  
end
