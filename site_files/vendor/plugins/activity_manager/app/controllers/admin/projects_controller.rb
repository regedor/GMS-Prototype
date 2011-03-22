class Admin::ProjectsController < Admin::BaseController
  filter_access_to :all,                               :require => any_as_privilege
  filter_access_to :create, :new, :delete, :destroy,   :require => :create

  active_scaffold :project do |config|

    config.columns[:groups].form_ui = :select
    config.columns[:groups].options = {:draggabledd_lists => true}

    Scaffoldapp::active_scaffold config, "admin.project", 
      :list     => [ :name, :description, :user ],        
      :show     => [ ],                                   
      :create   => [ :name, :description, :users ],       
      :edit     => [ :name, :description, :users ]        
  end                                                     

  def do_list
    require 'ostruct'
    #If root, show all
    if current_user.role.id == 7
      @records = Project.all
    else  
      @records = Project.find_all_for_user current_user
    end  
    @page = OpenStruct.new :items => @records, :number => @records.size, :pager => OpenStruct.new({ :infinite? => false, :count => @records.size, :number_of_pages => @records.size/15})
  end

  def show
    @project = Project.find(params[:id])
    redirect_to admin_project_to_do_lists_path(@project)
  end

  def edit
    @project = Project.find(params[:id])
    @users = User.all
    
    render :edit
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
    #project.users << current_user
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
    @users = User.all
    @project.users << current_user

    render :new
  end

end
