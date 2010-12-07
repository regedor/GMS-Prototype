class Admin::GroupsController < Admin::BaseController
  
  active_scaffold :group do |config|
    config.subform.columns = [:name]

    config.nested.add_link("<img src='/images/icons/book_open.png'/>History", [:action_entries])
   
    config.columns[:groups].form_ui = :select
    config.columns[:groups].options = {:draggable_lists => true}
    config.columns[:direct_users].form_ui = :select 
    config.columns[:direct_users].options = {:draggable_lists => true}
    
    Scaffoldapp::active_scaffold config, "admin.groups",
      :list     => [ :name, :mailable, :description ],
      :show     => [ :name, :description, :mailable, :users, :all_users_names ],
      :create   => [ :name, :description, :mailable, :user_choosable, :groups, :direct_users ],
      :edit     => [ :name, :description, :mailable, :user_choosable, :groups, :direct_users ],
      :row_mark => [ :delete_by_ids ]
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
