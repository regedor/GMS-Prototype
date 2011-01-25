class Admin::ToDoListsController < Admin::BaseController
  
  def index
    @lists = Project.find(params[:project_id]).to_do_lists
  end  
  
  def changeState
    todo = ToDo.find(params[:id])
    todo.done = (params[:state] == "done") ? true : false   
    todo.finished_date = Time.now
    todo.save 
    
    date = (params[:state] == "done") ? I18n::l(todo.finished_date, :format => :short) : I18n::l(todo.due_date, :format => :medium)
    
    respond_to do |format|
      format.js { render :text => params[:id]+"&"+date }
    end  
  end   
  
end  

