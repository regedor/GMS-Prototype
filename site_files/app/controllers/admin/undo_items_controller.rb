class Admin::UndoItemsController < Admin::BaseController
  
  active_scaffold :undo_item do |config|
    config.actions.swap :search, :live_search
    config.actions.exclude :update, :delete, :show, :create
    
    config.actions << :show
    config.action_links.add 'undo', :label => 'Undo', :type => :member, :page => true, :crud_type => :update, :method => :post
  


    Scaffoldapp::active_scaffold config, "admin.undo_items", [:created_at, :type]
   
  end
  
 def undo
   item = UndoItem.find(params[:id])
   begin
     object = item.process!

     respond_to do |format|
       format.html {
         flash[:notice] = item.complete_description
         redirect_to(:back)
       }
       format.json {
         render :json => {
           :message => item.complete_description,
           :obj     => object
         }
       }
     end
   rescue UndoFailed
     msg = "Could not undo, would result in an invalid state (i.e. a comment with no post)"
     respond_to do |format|
       format.html {
         flash[:notice] = msg
         redirect_to(:back)
       }
       format.json {
         render :json => { :message => msg }
       }
     end
   end
 end
end
