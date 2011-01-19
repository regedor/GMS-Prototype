class Admin::ProjectsController < Admin::BaseController
  #filter_access_to :all, :require => any_as_privilege
  
  active_scaffold :project do |config|
    
    config.columns[:groups].form_ui = :select
    config.columns[:groups].options = {:draggable_lists => true}
    
    Scaffoldapp::active_scaffold config, "admin.project",
      :list     => [ :name, :description ],
      :show     => [ :name, :description, :user_id, :groups ],
      :create   => [ :name, :description, :groups ],
      :edit     => [ :name, :description, :groups ],
      :row_mark => [  ]
  end
  
  def show
    @project = Project.find(params[:id])
  end  
  
  def create
    project = Project.new
    record = params[:record]
    project.name = record[:name]
    project.description = record[:description]
    project.user_id = current_user.id
    if record[:groups]
      record[:groups].each do |k,v|
        project.groups << Group.find(v[:id])
      end  
    end  
    project.save
    
    redirect_to admin_projects_path
  end  
  
end