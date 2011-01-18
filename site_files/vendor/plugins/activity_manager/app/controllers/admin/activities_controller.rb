class Admin::ActivitiesController < Admin::BaseController
  #filter_access_to :all, :require => any_as_privilege
  
  active_scaffold :activity do |config|
    
    #config.columns[:groups].form_ui = :select
    #config.columns[:groups].options = {:draggable_lists => true}
    
    Scaffoldapp::active_scaffold config, "admin.activity",
      :list     => [ :name, :description ],
      :show     => [ :name, :description, :user_id, :groups ],
      :create   => [ :name, :description, :groups ],
      :edit     => [ :name, :description, :groups ],
      :row_mark => [  ]
  end
  
  def create
    activity = Activity.new
    record = params[:record]
    activity.name = record[:name]
    activity.description = record[:description]
    activity.created_by = current_user
    record[:groups].each do |k,v|
      activity.groups << Group.find(v[:id])
    end  
    activity.save
    
    redirect_to admin_activities_path
  end  
  
end