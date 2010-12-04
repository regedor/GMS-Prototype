class Admin::ActionEntriesController < Admin::BaseController
  
  active_scaffold :action_entry do |config|
    config.actions.swap :search, :live_search
    config.actions.exclude :update, :delete, :show, :create, :live_search
    
    config.actions << :show
    config.action_links.add 'undo', :label => "<img src='/images/icons/book_previous.png'/>Revert", :type => :member, :page => true, :crud_type => :update, :method => :post
  
    config.show.columns.exclude :action,:undo

    Scaffoldapp::active_scaffold config, "admin.action_entry", [:created_at]
   
  end  
  
 # def count_includes
 #    " "  
 # end  
  
 def custom_finder_options
    return { :order => 'created_at DESC'}
 end  
  
 #Does the undo for an action    
 def undo
   #Gets the item for the id
   item = ActionEntry.find(params[:id])
   
   if item.controller == "admin/users"
     item.user.revertTo(item.undo)
     newer_entries = ActionEntry.all(:conditions => "id >= #{item.id}")
     newer_entries.map(&:destroy)
      #Re-renders the page
     redirect_to :controller => "admin/users", :action => "index"
   end
   
  
   
 end
end
