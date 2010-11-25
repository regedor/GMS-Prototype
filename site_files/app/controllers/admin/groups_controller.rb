class Admin::GroupsController < Admin::BaseController
  
  after_filter :save_action
  
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
    ]
    
    config.show.columns.exclude :updated_at, :users
    config.show.columns << :all_users_names
    
  end
  
  
  #TODO Different messages for each action
  
  def save_action
    @loggable_actions = [:destroy,:create,:update]
    if @loggable_actions.include?(params[:action].to_sym)
      entry = ActionEntry.new({:controller=>params[:controller],:action=>params[:action],:message=>"No Message"})
      entry.set_undo_for(params[:action])
      entry.save
    end
  end  
  
end  
