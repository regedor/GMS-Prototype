class EventsController < ApplicationController

  def unsubscribe
    @event = Event.find(params[:id])
    eventUser = EventsUser.find_by_event_id_and_user_id(@event.id,current_user.id)
        
    EventActivitiesUser.find_by_event_id_and_user_id(@event.id,current_user.id).to_a.map(&:destroy)
    if eventUser && eventUser.destroy
      flash[:notice] = t('flash.unsubscribe', :name => @event.name)
      redirect_to root_path
    else
      flash[:error] = t('flash.unsubscribe_error')
    end
  end  

  def subscribe
    @event = Event.find(params[:id])
    user = User.find(current_user.id)
    if params[:event][:user].has_value?("") || !user.update_attributes(params[:event][:user])
      flash.now[:error] = t('flash.subscribe_error')
      render :partial => 'posts/show_event',:layout => true, :locals => {:event => @event, :total_price => @event.price, :subscribed_activities  => []}
      return
    end  
    params[:event].delete :user
    
    activities = []
    activities_price = 0
    params[:event][:event_activity_ids].reject(&:blank?).map do |id|
      activity = EventActivity.find id
      activities << activity
      activities_price += activity.price
    end if params[:event] && params[:event][:event_activity_ids]
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
    
    flash.now[:notice] = t('flash.subscribe', :name => @event.name)
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
