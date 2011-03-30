class Admin::EventActivityManageController < Admin::BaseController

  def show
    if params[:search]
      search(params[:search])
    else
      refreshContent
    end
  end

  def index
    if params[:event_activity_id]
      eventid = EventActivity.find(params[:event_activity_id]).event_id
      redirect_to admin_event_event_activity_manage_path(eventid,params[:event_activity_id])
    end
  end

  def refreshContent
    @record = EventActivity.find(params[:id])
    @user_lists = @record.user_lists
    @statuses = Status.all
  end

  def search(stringProcura)
    @record = EventActivity.find(params[:id])
    events_users = EventActivitiesUser.find_by_event_activity_id_and_text(@record.id,stringProcura)
    @user_lists = EventActivity.user_lists(events_users)
    @statuses = Status.all
  end

  def confirmUpdate

    eventid = params[:id]
    update_status_activity = params[:idsa].split(',')

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
