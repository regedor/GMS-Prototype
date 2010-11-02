class Admin::GroupsController < Admin::BaseController
  
  active_scaffold :group do |config|
    config.actions.swap :search, :live_search   
    config.actions.exclude :update, :delete, :show, :create

    config.actions << :show
    config.actions << :update
    config.actions << :delete
    config.actions << :create
        
    config.create.columns = [:name, :description, :mailable, :parent_group, :subgroups, :users]
    config.subform.columns.exclude :description, :mailable

    Scaffoldapp::active_scaffold config, "admin.groups", [
      :name, :mailable, :description, :parent_name     # Parent is a method defined in models/group.rb
    ], true
    
    #config.show.columns.exclude :users
    config.show.columns.exclude :updated_at
    config.show.columns << :all_users_names
    
  end
  
end  