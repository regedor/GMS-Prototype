class Admin::ToDosController < Admin::BaseController

  def create
    todo = ToDo.new
    todo.user_id = params[:todo][:responsible]
    todo.to_do_list_id = params[:todo][:to_do_list_id]
    todo.description = params[:todo][:description]
    todo.due_date = params[:todo][:due_date] 
    todo.save
    
    redirect_to admin_project_to_do_lists_path(params[:project_id])
  end 

end
