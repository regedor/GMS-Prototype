class Admin::GroupsController < Admin::BaseController
  
  active_scaffold :group do |config|
    config.actions.swap :search, :live_search
    
    config.create.columns = [:name, :description, :mailable, :parent_group, :subgroups, :users]
    config.subform.columns.exclude :description, :mailable

    Scaffoldapp::active_scaffold config, "admin.groups", [
      :name, :mailable, :description, :parent     # Parent is a method defined in models/group.rb
    ], true
  end
  
end  