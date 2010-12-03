class Root::GroupsController < Admin::BaseController
  
  active_scaffold :group do |config|
    config.actions.swap :search, :live_search   
    config.actions.exclude :update, :delete, :show, :create

    config.actions << :show
    config.actions << :update
    config.actions << :delete
    config.actions << :create

    # Redefining delete method
    config.delete.link.controller = nil
    config.delete.link.method = nil
    config.delete.link.action = 'delete_group'
    config.delete.link.page = true
    config.delete.link.inline = "admin/groups"
        
    config.create.columns = [:name, :description, :mailable, :parent_group, :subgroups, :users]
    config.subform.columns.exclude :description, :mailable

    config.show.columns.exclude :updated_at, :users
    config.show.columns << :all_users_names
    
    Scaffoldapp::active_scaffold config, "admin.groups", [
      :name, :mailable, :description, :parent_name      # Parent is a method defined in models/group.rb
    ]
   
  end

  # Method to filter which rows will appear.
  # Only groups non managelable by root only be visible
  def custom_finder_options
    return { :conditions => {:manageable_by_root_only => false} }
  end

end
