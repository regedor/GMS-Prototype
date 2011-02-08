class Admin::ProjectsController < Admin::BaseController
  filter_access_to :all,           :require => any_as_privilege
  filter_access_to :create, :new, :require => :create

  active_scaffold :project do |config|

    config.columns[:groups].form_ui = :select
    config.columns[:groups].options = {:draggabledd_lists => true}

    Scaffoldapp::active_scaffold config, "admin.project",
      :list     => [ :name, :description ],
      :show     => [ ],
      :create   => [ :name, :description, :users ],
      :edit     => [ :name, :description, :users ]
  end

  def do_list 
    require 'ostruct'
    @records = Project.find_all_for_user current_user
    @page = OpenStruct.new :items => @records, :number => @records.size, :pager => OpenStruct.new({ :infinite? => false, :number_of_pages => @records.size/15})
  end

  def show
    @project = Project.find(params[:id])
    redirect_to admin_project_to_do_lists_path(@project)
  end

  def create
    params[:record][:user_id] = current_user.id
    super
    #project             = Project.new
    #record              = params[:record]
    #project.name        = record[:name]
    #project.description = record[:description]
    #project.user        = current_user
    #if record[:users]
    #  record[:users].each do |k,v|
    #    project.users << User.find(v[:id])
    #  end
    #end
    #project.save

    #redirect_to admin_projects_path
  end

end
