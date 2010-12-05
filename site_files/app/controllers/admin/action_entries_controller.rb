class Admin::ActionEntriesController < Admin::BaseController
  
  active_scaffold :action_entry do |config|
    config.actions.swap :search, :live_search
    config.actions.exclude :update, :delete, :show, :create, :live_search
    
    config.actions << :show
    config.action_links.add 'revert', :label => "<img src='/images/icons/book_previous.png'/>Revert", :type => :member, :page => true, :crud_type => :update, :method => :post
  
    config.show.columns = [:controller, :created_at, :message]

    Scaffoldapp::active_scaffold config, "admin.action_entry", [:created_at]
   
  end    
  
 def custom_finder_options
    if !params[:nested]
      return { :order => 'created_at DESC', :conditions => {:action => "delete"}}
    else  
      return { :order => 'created_at DESC'}
    end  
 end  
  
 #Does the undo for an action    
 def revert
   #Gets the item for the id
   item = ActionEntry.find(params[:id])
   if item.controller == "admin/users"
     item.user.revertTo(item.xml_hash)
   elsif item.controller == "admin/groups"
     item.group.revertTo(item.xml_hash)
   end   
        
   newer_entries = ActionEntry.all(:conditions => "id >= #{item.id}")
   newer_entries.map(&:destroy)
  
  #Re-renders the page
  redirect_to :controller => item.controller, :action => "index"
   
 end
end
