class Admin::ProjectsController < Admin::BaseController
  filter_access_to :all,                               :require => any_as_privilege
  filter_access_to :create, :new, :delete, :destroy,   :require => :create

  active_scaffold :project do |config|

    Scaffoldapp::active_scaffold config, "admin.project", 
      :list     => [ :name, :description, :user ],        
      :show     => [ ],                                   
      :create   => [ :name, :description, :group ],       
      :edit     => [ :name, :description, :group ]        
  end                                                     
  
  def conditions_for_collection
    unless current_user.role_id == 7 || current_user.role_id == 6
      ['projects.group_id IN (?)', current_user.group_ids]
    end
  end  


  def show
    @project = Project.find(params[:id])
    redirect_to admin_project_to_do_lists_path(@project)
  end

  def edit
    @project = Project.find(params[:id])
    @groups = Group.all
  end  
  
  def update
    project = Project.find(params[:id])
    project.attributes = params[:project]
    project.save
    
    redirect_to admin_projects_path
  end  
  
  def destroy
    project = Project.find(params[:id])
    if project.destroy
      flash[:notice] = t("flash.project_deleted",:project => project.name)
    else
      flash[:error] = t("flash.project_creation_fail",:project => project.name)
    end    
    
    redirect_to admin_projects_path
  end  

  def create
    project = Project.new params[:project]
    project.user = current_user
    if project.save
      flash[:notice] = t("flash.project_created")   
      redirect_to admin_projects_path 
    else
      @project = project
      render :new
    end    
  end

  def new
    @project = Project.new
    @groups = Group.all
  end

end
