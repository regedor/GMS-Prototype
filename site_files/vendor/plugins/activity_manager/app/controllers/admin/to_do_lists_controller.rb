class Admin::ToDoListsController < Admin::BaseController
  
  def index
    @lists = ToDoList.all
  end  
  
  def changeState
    if params[:state] == "done"
      todo = ToDo.find(params[:id])
      todo.done = true;
      todo.save
    else
      todo = ToDo.find(params[:id])
      todo.done = false;
      todo.save  
    end
    
    @lists = ToDoList.all
    respond_to do |format|
      format.js { render :text => params[:id].to_s }
    end  
    
    #redirect_to :action  => :index
  end   
  
end  