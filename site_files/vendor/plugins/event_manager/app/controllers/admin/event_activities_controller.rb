class Admin::EventActivitiesController < Admin::BaseController

  before_filter :date_localization, :only => [ :create, :update ]

  active_scaffold :event_activity do |config|
    Scaffoldapp::active_scaffold config, "admin.event.activities",
      #:show   => [ :title, :description, :starts_at, :ends_at, :price ],
      :show   => [ ],
      :create => [ :title, :description, :starts_at, :ends_at, :price ],
      :edit   => [ ],
      :list   => [ :title, :starts_at, :ends_at, :price ]
  end


#  def new
#   @activity = EventActivity.new({:event_id => params[:id]})
#  end

  def create
    @activity = EventActivity.new
    @activity.attributes = params[:record]        
    @activity.event_id = params[:event_id]
    @activity.save!
    redirect_to admin_event_event_activities_path(params[:event_id])
  end

  def show
    eventid = EventActivity.find(params[:id]).event_id
    redirect_to :action => 'index', :controller => 'admin/event_activity_manage', :event_activity_id => params[:id], :event_id => eventid
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

#  def before_create_save(record)
#    record.event_id = params[:event_id]
#  end

end
