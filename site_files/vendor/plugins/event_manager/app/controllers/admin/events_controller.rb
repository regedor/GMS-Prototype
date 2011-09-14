class Admin::EventsController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege

  before_filter :date_localization, :only => [ :create, :update ]
  before_filter :validate_data, :only => [ :create, :update ]

  active_scaffold :event do |config|
  
    config.action_links.add 'list_activities', :type => :member, :page => true, :method => :get,
                                     :label => I18n::t("admin.events.index.list_activities")    

    Scaffoldapp::active_scaffold config, "admin.events",
      :create => [ :name, :description, :starts_at, :ends_at, :price, :participation_message ],
      :edit   => [ :name, :description, :starts_at, :ends_at, :price, :participation_message ],
      :list   => [ :name, :starts_at, :ends_at, :price ],
      :show   => [ ]
  end

  def new
    @record = Event.new
    @record.build_post
    @record.build_announcement
    
    render :create
  end  

  def create
    activities = params[:record][:event_activities_attributes]
    params[:record].delete(:event_activities_attributes)
    @record = Event.new params[:record]      
      
    if @record.save
      if activities
        activities.each do |k,value|
          ea = EventActivity.new value
          ea.event = @record
          ea.starts_at = (DateTime.strptime value[:starts_at], "%d/%m/%Y %H:%M").to_datetime
          ea.ends_at = (DateTime.strptime value[:ends_at], "%d/%m/%Y %H:%M").to_datetime        
          ea.save
        end
      end
      flash[:notice]  = t("flash.eventCreated.successfully",:name => @record.name)
      redirect_to admin_events_path 
    else
      @template.properly_show_errors @record.post
      @template.properly_show_errors @record.post if @record.post
      @template.properly_show_errors @record.announcement if @record.announcement
      flash.now[:error] = t("flash.eventCreated.error")
    end
  end  
  
  def edit
    @record = Event.find params[:id]
    @record.build_post unless @record.post
    @record.build_announcement unless @record.announcement
    
    render "admin/events/update"
  end
  
  def update
    activities = params[:record][:event_activities_attributes]
    params[:record].delete(:event_activities_attributes)
    @record = Event.find params[:id]
    @record.update_attributes params[:record]   
               
    if @record.save
      if activities
        activities.each do |k,value|
          if value.member? :id
            ea = EventActivity.find value[:id]
          else  
            ea = EventActivity.new value
          end  
          ea.event = @record
          ea.starts_at = (DateTime.strptime value[:starts_at], "%d/%m/%Y %H:%M").to_datetime
          ea.ends_at = (DateTime.strptime value[:ends_at], "%d/%m/%Y %H:%M").to_datetime
          ea.save
        end
      end
      flash[:notice]  = t("flash.eventUpdated.successfully",:name => @record.name)
      redirect_to admin_events_path 
    else
      @template.properly_show_errors @record
      @template.properly_show_errors @record.post if @record.post
      @template.properly_show_errors @record.announcement if @record.announcement
      flash.now[:error] = t("flash.eventUpdated.error")
    end    
  end  
  
  

  def list_activities
    redirect_to :action => 'index', :controller => 'admin/event_activities', :event_id => params[:id]
  end

  def show
    redirect_to :action => 'index', :controller => 'admin/event_manage', :event_id => params[:id]
  end

  def refreshContent
    @record = Event.find(params[:id])
    @checked_activities = @record.checked_activities(current_user.id)
    @unchecked_activities = @record.unchecked_activities(current_user.id)
  end
 
  def userUpdate

    eventid = params[:id]
    to_delete = params[:idsu].split(',')
    to_create = params[:idsc].split(',')

    to_delete.each do |activity_id|
      activity = EventActivitiesUser.find_by_event_activity_id_and_user_id(activity_id,current_user.id)
      activity.destroy if activity
    end

    to_create.each do |activity_id|
      activity = EventActivitiesUser.new(:event_activity_id => activity_id, :user_id => current_user.id)
      activity.save!
    end

    if (params[:joinEvent] == 'true')
      evento = Event.find(eventid)
      evento.users << current_user
      evento.save!
    elsif (params[:joinEvent] == 'false')
      evento = Event.find(eventid)
      user_event = evento.events_users.find_by_user_id(current_user.id)
      user_event.destroy if user_event
    end

    refreshContent

    event_user = EventsUser.find_by_event_id_and_user_id(eventid,current_user.id)
    if event_user
      respond_to do |format|
        format.json { render :json => {
              'id'   => eventid,
              'html' => '<h2>' +
                  event_user.event.participation_message.to_s + 
                  '</h2> <br> <br> ' + 
                  t("admin.events.view.totalprice") + 
                  ': ' + event_user.total_price.to_s + ' <br> <br> ' +
                  '<a href="" onclick="windows.location.href=\"\"" class="cancel">' + t("admin.events.view.cancel") + '</a>'
          }
        }
       end
    else   
      respond_to do |format|
        format.json { render :json => { 'id' => false } }
      end
    end

  end

  protected

    def validate_data
      params[:record].delete(:announcement_attributes) if params[:record][:has_announcement].size == 1
      if params[:record][:has_announcement].size == 1
        params[:record][:has_announcement] = false
      else
        params[:record][:has_announcement] = true
      end
      params[:record][:post_attributes][:title] = params[:record][:name]
    end  

    def date_localization
      params[:record][:post_attributes][:published_at] = (Date.strptime params[:record][:post_attributes][:published_at], "%d/%m/%Y").to_datetime
      [:starts_at, :ends_at].each do |attribute|
        params[:record][attribute] = DateTime.strptime(params[:record][attribute], "%d/%m/%Y %H:%M").to_datetime
      end
      if params[:record][:announcement_attributes]
        [:starts_at, :ends_at].each do |attribute|
          params[:record][:announcement_attributes][attribute] = DateTime.strptime(params[:record][:announcement_attributes][attribute], "%d/%m/%Y %H:%M").to_datetime unless params[:record][:announcement_attributes][attribute].blank?
        end
      end
    end

end
