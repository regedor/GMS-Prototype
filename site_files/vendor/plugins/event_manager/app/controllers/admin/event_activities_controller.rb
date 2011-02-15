class Admin::EventActivitiesController < Admin::BaseController

  active_scaffold :event_activity do |config|
    Scaffoldapp::active_scaffold config, "admin.event.activities",
      :show   => [ :title, :description, :starts_at, :ends_at, :price ]#,
     # :create => [ :title, :description, :starts_at, :ends_at, :price ]
  end

  def new
   @activity = EventActivity.new({:event_id => params[:event_id]})
  end

  def create
    @activity = EventActivity.new
    @activity.attributes = params[:event_activity]
    @activity.event_id = params[:event_id]
    @activity.save!
    redirect_to admin_event_path(@activity.event_id)
  end

  def edit
    @activity = EventActivity.find(params[:id])
  end

  def update
    @activity = EventActivity.find(params[:id])
    @activity.update_attributes(params[:event_activity])
    @activity.save!
    redirect_to admin_event_event_activity_path(@activity.event_id,@activity.id)
  end

  def index
    redirect_to admin_event_path(params[:event_id])
  end

#  def before_create_save(record)
#    record.event_id = params[:event_id]
#  end

end
