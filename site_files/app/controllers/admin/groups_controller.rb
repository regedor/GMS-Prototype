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
    config.update.columns = [:name, :description, :mailable, :parent_group, :subgroups, :users]

    config.nested.add_link("<img src='/images/icons/book_open.png'/>History", [:action_entries])

    Scaffoldapp::active_scaffold config, "admin.groups", [
      :name, :mailable, :description, :parent_name     # Parent is a method defined in models/group.rb
    ]
    
    config.show.columns.exclude :updated_at, :users
    config.show.columns << :all_users_names
    
  end
  
  def before_update_save(record)
    @loggable_actions = [:destroy,:create,:update]
    if @loggable_actions.include?(params[:action].to_sym)
      group = Group.find_by_id(params[:id])
      entry = ActionEntry.new({:controller=>params[:controller],:action=>params[:action],:message=>group.pretty_print,:entity_id=>group.id})
      entry.xml_hash = group.to_xml
      entry.save 
    end
  end
  
end  
