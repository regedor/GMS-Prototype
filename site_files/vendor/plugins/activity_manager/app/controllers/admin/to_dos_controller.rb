class Admin::ToDosController < Admin::BaseController

  def new
    @project = Project.find(params[:project_id])
    @todolist = ToDoList.find(params[:parentlist])
    @todo = ToDo.new()
    @user = User.find(params[:todo][:responsible])
    @todo.user = @user
    @todo.to_do_list = @todolist
    @todo.description = params[:todo][:description]
    @todo.save!
    redirect_to admin_project_to_do_lists_path(@project)
  end

end
