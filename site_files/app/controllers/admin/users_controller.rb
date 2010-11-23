class Admin::UsersController < Admin::BaseController
  active_scaffold :user do |config|
    config.actions.swap :search, :live_search
    config.actions.exclude :update, :delete, :show, :create

    config.actions << :show
    config.actions << :update
    config.actions << :delete

    config.delete.link.controller = nil
    config.delete.link.method = nil
    config.delete.link.action = 'do_action'
    config.delete.link.parameters = { "actions" => "destroy_by_ids" }
    config.delete.link.page = true

    config.show.columns = [ :email, :active, :nickname, :profile, :website, :country, :gender ]
    
    config.subform.columns.exclude :email, :active, :password, :nickname, :profile, :website,
     :language, :country, :gender, :role, :phone, :crypted_password, :current_login_at, :last_login_at, :current_login_ip, :last_login_ip,
     :persistence_token, :single_access_token, :perishable_token, :openid_identifier, :password_salt, :last_request_at

    Scaffoldapp::active_scaffold config, "admin.users", [:created_at, :email, :active, :language, :name, :role], 
    [:destroy_by_ids, :activate!, :deactivate!]
  end

  # Override this method to provide custom finder options to the find() call.
  # With this, only the users with the value 'false' in the column 'deleted' will be shown.
  def custom_finder_options
    return { :conditions => {:deleted => false} }
  end

  
  # Method that receives all requests and calls the desired action with the selected ids,
  # and returns the re-rendered html
  def do_action
    if !params[:ids].nil?
      ids = params[:ids].split('&')
    else ids = [ params[:id] ]
    end
    if User.send(params[:actions],ids)  
      entry = ActionEntry.new({:controller=>params[:controller],:action=>params[:actions],:message=>"No message"})
      entry.save
      list
    else
      render :text => "" 
    end      
  end
  
end
