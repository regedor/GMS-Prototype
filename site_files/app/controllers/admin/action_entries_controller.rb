class Admin::ActionEntriesController < Admin::BaseController
  
  active_scaffold :action_entry do |config|
    
    config.action_links.add 'undo', :type => :member, :page => true, :crud_type => :update, :method => :post,
                            :label => "<img src='/images/icons/book_previous.png'/>Revert"

    Scaffoldapp::active_scaffold config, "admin.action_entry",
      :list     => [ :created_at ],
      :show     => [ :controller, :created_at, :message ],
      :delete   => false

    config.show.link.page = false
    config.list.label ="adfasdf"
    config.actions.exclude :live_search

    config.action_links.add 'show', :type => :member, :page => false, :label => "asdfasdf"
  end    
  
 def custom_finder_options
    if !params[:nested]
      return { :order => 'created_at DESC', :conditions => {:action => "delete"}}
    else  
      return { :order => 'created_at DESC'}
    end  
 end  
  
 #Does the undo for an action    
 def undo
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
