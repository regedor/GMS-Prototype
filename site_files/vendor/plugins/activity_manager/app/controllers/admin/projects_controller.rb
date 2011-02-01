class Admin::ProjectsController < Admin::BaseController
  #filter_access_to :all, :require => any_as_privilege
  
  def index
    @project = Project.find(params[:id])
    
    redirect_to admin_project_to_do_lists_path(@project)
  end  
  
  def show
    @project = Project.find(params[:id])
    
    redirect_to admin_project_to_do_lists_path(@project)
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