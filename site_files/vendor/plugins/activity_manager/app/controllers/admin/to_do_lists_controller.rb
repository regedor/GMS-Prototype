class Admin::ToDoListsController < Admin::BaseController
  
  def index
    @lists = ToDoList.all
  end  
  
  def changeState
    todo = ToDo.find(params[:id])
    todo.done = (params[:state] == "done") ? true : false   
    todo.finished_date = Time.now
    todo.save 
    
    respond_to do |format|
      format.js { render :text => params[:id]+"&"+I18n::l(todo.finished_date, :format => :short) }
    end  
  end   
  
end  