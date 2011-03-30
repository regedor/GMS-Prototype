class Admin::EventManageController < Admin::BaseController

  def index
    if params[:search]
      search(params[:search])
    else
      refreshContent
    end
  end

  def refreshContent
    @record = Event.find(params[:event_id])
    @user_lists = @record.user_lists
    @user_activities = @record.user_activities
    @statuses = Status.all
  end

  def search(stringProcura)
    @record = Event.find(params[:event_id])
    events_users = EventsUser.find_by_event_id_and_text(@record.id,stringProcura)
    @user_lists = Event.user_lists(events_users)
    @user_activities = @record.user_activities
    @statuses = Status.all
  end

  def confirmUpdate

    eventid = params[:event_id]
    update_status_event = params[:idse].split(',')
    update_status_activity = params[:idsa].split(',')

    update_status_event.each do |event_id|
      event_id = event_id.split(':')
      event = EventsUser.find(event_id[0])
      event.updateStatus(event_id[1]) if event
    end

    update_status_activity.each do |event_id|
      event_id = event_id.split(':')
      event = EventActivitiesUser.find(event_id[0])
      event.updateStatus(event_id[1]) if event
    end
    
    refreshContent

    respond_to do |format|
      format.js { render :text => "" }
    end

  end

end
