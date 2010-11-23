class Admin::GroupsController < Admin::BaseController
  
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

    Scaffoldapp::active_scaffold config, "admin.groups", [
      :name, :mailable, :description, :parent_name     # Parent is a method defined in models/group.rb
    ]
    
    #config.show.columns.exclude :users
    config.show.columns.exclude :updated_at, :users
    config.show.columns << :all_users_names
    
  end

  # Override this method to define conditions to be used when querying a recordset (e.g. for List).
  # With this, only the groups with the value 'false' in the column 'deleted' will be shown.
  def conditions_for_collection
    return { :deleted => false }
  end

  # This method applies not_deleted scope to find method
  # Redefine actions to check this first to ensure that only applies to non-deleted groups
  def check_undeleted(id)
    return false unless Group.not_deleted.find(id)
    return true
  end

  def show
    if check_undeleted(params[:id])
      super
    end
  end

  def edit
    if check_undeleted(params[:id])
      super
    end
  end

  def update
    if check_undeleted(params[:id])
      super
    end
  end

  def delete_group
    id = params[:id]
    if Group.send(:destroy,id)
      list
    else
      render :text => "" 
    end     
  end
  
end  
