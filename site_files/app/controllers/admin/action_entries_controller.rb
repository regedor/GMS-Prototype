class Admin::ActionEntriesController < Admin::BaseController
  
  active_scaffold :action_entry do |config|
    config.actions.swap :search, :live_search
    config.actions.exclude :update, :delete, :show, :create
    
    config.actions << :show
    config.action_links.add 'undo', :label => "<img src='/images/icons/arrow_undo.png'/>Undo", :type => :member, :page => true, :crud_type => :update, :method => :post
  

    Scaffoldapp::active_scaffold config, "admin.action_entry", [:created_at, :controller, :action, :users_performed_on]
   
  end
  
  
  #Overrides find so that it only shows the actions that can be undone
  def custom_finder_options
     return { :conditions => "undo IS NOT NULL" }
  end  
  
 #Does the undo for an action    
 def undo
   #Gets the item for the id
   item = ActionEntry.find(params[:id])
   
   if item.controller == "admin/users"
     #Gets the ids for the users
     match = item.message[/Performed on ids: \[(.*)\]/]
     value = $1
     
     #Transforms the string with ids into an array
     ids = value.split(/\"/).map(&:to_i).map(&:nonzero?).compact!
   end
   
   #Tries to undo, destroing the action if successful
   if User.send(item.undo,ids)
     item.destroy
   end 
   
   #Re-renders the page
   index
 end
end
