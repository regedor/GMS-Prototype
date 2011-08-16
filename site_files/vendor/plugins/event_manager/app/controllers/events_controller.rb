class EventsController < ApplicationController

  def unsubscribe
    @event = Event.find(params[:id])
    eventUser = EventsUser.find_by_event_id_and_user_id(@event.id,current_user.id)
    eventUser.status_id = 4 #unsubscribed
    
    EventActivitiesUser.find_by_event_id_and_user_id(@event.id,current_user.id).to_a.map(&:destroy)
    if eventUser.save
      flash[:notice] = t('flash.unsubscribe', :name => @event.name)
      redirect_to root_path
    else
      flash[:error] = t('flash.unsubscribe_error')
    end
  end  

  def subscribe
    @event = Event.find(params[:id])
    activities = []
    activities_price = 0
    params[:event][:event_activity_ids].reject(&:blank?).map do |id|
      activity = EventActivity.find id
      activities << activity
      activities_price += activity.price
    end if params[:event]
    @total_price = @event.price + activities_price
    eventsUser = EventsUser.find_by_event_id_and_user_id(@event.id,current_user.id)
    unless eventsUser
      eventsUser = EventsUser.create :event_id => @event.id, :user_id => current_user.id, :status_id => 2, :total_price => @total_price
      @event.events_users << eventsUser 
      @event.save
    else
      eventsUser.status_id = 2
      eventsUser.total_price = @total_price
      eventsUser.save
    end             

    @subscribed_activities = []
    activities.each do |activity|      
      activitiesUser = EventActivitiesUser.find_by_event_id_and_user_id_and_event_activity_id(@event.id,current_user.id,activity.id)
      if activitiesUser.nil?
        activitiesUser = EventActivitiesUser.create :event_activity_id => activity.id, :event_id => @event.id, :user_id => current_user.id, :status_id => 2
      else
        activitiesUser.status_id = 2
        activitiesUser.save
      end    
      @subscribed_activities << activitiesUser
      activity.event_activities_users << activitiesUser   
      activity.save                                                              
    end unless activities.empty?
  end

  def show
    refreshContent
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
                  '<a href="" onclick="windows.location.href=\"\"" class="cancel">' + t("events.view.cancel") + '</a>'
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

    def date_localization
      begin
        [:starts_at, :ends_at].each do |attribute|
          params[:record][attribute] = DateTime.strptime(params[:record][attribute], "%d/%m/%Y %H:%M").to_time
        end
      rescue ArgumentError
        flash[:error] = t("flash.invalid_date")
        redirect_to :action => params[:action] == 'create' ? 'new' : 'edit'
        return
      end
    end

end
