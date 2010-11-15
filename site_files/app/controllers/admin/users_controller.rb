class Admin::UsersController < Admin::BaseController
  active_scaffold :user do |config|
    config.actions.swap :search, :live_search
    config.actions.exclude :update, :delete, :show, :create

    config.actions << :show
    config.actions << :update
    config.actions << :delete

    config.show.columns = [ :email, :active, :nickname, :profile, :website, :country, :gender ]
    #config.columns[:crypted_password].label = "password"
    
    config.subform.columns.exclude :email, :active, :password, :nickname, :profile, :website,
     :language, :country, :gender, :role, :phone, :crypted_password, :current_login_at, :last_login_at, :current_login_ip, :last_login_ip,
     :persistence_token, :single_access_token, :perishable_token, :openid_identifier, :password_salt, :last_request_at

    Scaffoldapp::active_scaffold config, "admin.users", [:created_at, :email, :active, :language, :name, :role], 
    [:destroy_by_ids, :activate!, :deactivate!]
    
    config.has_sidebar = true
  end
  
  
  # Method that receives all requests and calls the desired action with the selected ids, 
  # returning a JSON object with the response
  def do_action
    ids = params[:ids].split('&')
    if User.send(params[:actions],ids)  
      list
    else
      render :text => "" 
    end      
  end
  
  
end
