class Admin::GroupsController < Admin::BaseController
  
  active_scaffold :group do |config|
    config.subform.columns = [:name]
    config.actions.swap :search, :live_search   
    config.actions.exclude :update, :delete, :show, :create

    config.actions << :show
    config.actions << :update
    config.actions << :delete
    config.actions << :create
        

    config.nested.add_link("<img src='/images/icons/book_open.png'/>History", [:action_entries])

    config.create.columns = [:name, :description, :mailable, :user_choosable, :groups, :direct_users]
    config.columns[:groups].form_ui = :select
    config.columns[:groups].options = {:draggable_lists => true, :name => :email}
    config.columns[:direct_users].form_ui = :select 
    config.columns[:direct_users].options = {:draggable_lists => true}
    
     
    config.show.columns = [ :name,  :description, :mailable, :users ]

    config.update.link.page=true

    config.show.columns << :all_users_names
    config.list.always_show_search = true
    
    Scaffoldapp::active_scaffold config, "admin.groups", [:name, :mailable, :description ],
      [:isto_symbol_devia_ser_delete_mas_alguem_fez_ma_i18n]
   
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
