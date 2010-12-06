class Admin::GroupsController < Admin::BaseController
  
  active_scaffold :group do |config|
    config.subform.columns = [:name]
    config.actions.swap :search, :live_search   
    config.actions.exclude :update, :delete, :show, :create

    config.actions << :show
    config.actions << :update
    config.actions << :delete
    config.actions << :create
<<<<<<< HEAD
=======
        
    config.create.columns = [:name, :description, :mailable, :parent_group, :subgroups, :users]
    config.subform.columns.exclude :description, :mailable
    config.update.columns = [:name, :description, :mailable, :parent_group, :subgroups, :users]

    config.nested.add_link("<img src='/images/icons/book_open.png'/>History", [:action_entries])
>>>>>>> origin/features/admin-actions

    config.create.columns = [:name, :description, :mailable, :user_choosable, :groups, :direct_users]
    config.columns[:groups].form_ui = :select
    config.columns[:groups].options = {:draggable_lists => true, :name => :email}
    config.columns[:direct_users].form_ui = :select 
    config.columns[:direct_users].options = {:draggable_lists => true}
    
<<<<<<< HEAD
     
    config.show.columns = [ :name,  :description, :mailable, :users ]

    config.update.link.page=true

=======
>>>>>>> origin/features/admin-actions
    config.show.columns.exclude :updated_at, :users
    config.show.columns << :all_users_names
    config.list.always_show_search = true
    
    Scaffoldapp::active_scaffold config, "admin.groups", [:name, :mailable, :description ],
      [:isto_symbol_devia_ser_delete_mas_alguem_fez_ma_i18n]
   
  end
<<<<<<< HEAD


end
=======
  
  def before_update_save(record)
    @loggable_actions = [:destroy,:create,:update]
    if @loggable_actions.include?(params[:action].to_sym)
      group = Group.find_by_id(params[:id])
      entry = ActionEntry.new({:controller=>params[:controller],:action=>params[:action],:message=>group.name+" has been altered",:user_id=>group.id})
      entry.set_undo_for(group.to_xml)
      entry.save
    end
  end
  
end  
>>>>>>> origin/features/admin-actions
