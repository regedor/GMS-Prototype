class Admin::UsersController < Admin::BaseController
  active_scaffold :user do |config|
    config.subform.columns = [:email]
    config.actions.swap :search, :live_search
    config.actions.exclude :update, :delete, :show, :create

    config.actions << :show
    config.actions << :update
    config.actions << :delete

    config.update.columns = [:email, :active, :nickname, :profile, :website, :country, :gender]
    config.columns[:groups].show_blank_record = false
    config.show.columns = [ :email, :active, :nickname, :profile, :website, :country, :gender ]


    config.nested.add_link("<img src='/images/icons/book_open.png'/>History", [:action_entries])
  
    Scaffoldapp::active_scaffold config, "admin.users", [:created_at, :email, :active, :name, :role], 
      [:destroy_by_ids, :activate!, :deactivate!]
  end

  # Override this method to define conditions to be used when querying a recordset (e.g. for List).
  # With this, only the users with the value 'false' in the column 'deleted' will be shown.
  def conditions_for_collection
    return { :deleted => false }
  end
  
  # Method that receives all requests and calls the desired action with the selected ids,
  # and returns the re-rendered html
  def do_action
    if !params[:ids].nil?
      ids = params[:ids].split('&')
    else ids = [ params[:id] ]
    end
    if User.send(params[:actions],ids)  
      ids.each do |id|
        user = User.find_by_id(id)
        entry = ActionEntry.new({:controller=>params[:controller],:action=>params[:actions],:message=>user.name+" has been altered",:entity_id=>user.id})
        entry.xml_hash = user.to_xml
        entry.save
      end  
      list
    else
      render :text => "" 
    end      
  end
  
  def before_update_save(record)
    @loggable_actions = [:destroy,:create,:update]
    if @loggable_actions.include?(params[:action].to_sym)
      user = User.find_by_id(params[:id])
      entry = ActionEntry.new({:controller=>params[:controller],:action=>params[:action],:message=>user.name+" has been altered",:entity_id=>user.id})
      entry.xml_hash = user.to_xml
      entry.save
    end
  end
  
end
