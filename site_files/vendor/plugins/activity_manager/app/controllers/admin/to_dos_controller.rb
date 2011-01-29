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
  
  def update
    todo = ToDo.find(params[:id])
    unless todo.done?
      todo.user_id = params[:todo][:responsible]
      todo.to_do_list_id = params[:todo][:to_do_list_id]
      todo.description = params[:todo][:description]
      todo.due_date = params[:todo][:due_date]
      todo.save
    else
      flash[:error] = t("admin.to_do.update.error")
    end    
    
    redirect_to admin_project_to_do_lists_path(params[:project_id])
  end
  
  def destroy
    todo = ToDo.find(params[:id])
    unless todo.done?
      todo.destroy
      respond_to do |format|
        format.js { render :text  => params[:id] }
      end
    else
      flash[:error] = t("admin.to_do.destroy.error")
      redirect_to admin_project_to_do_lists_path(params[:project_id])
    end      
  end  

end
