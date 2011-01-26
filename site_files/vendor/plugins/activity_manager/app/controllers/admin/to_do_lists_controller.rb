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
  
  def edit 
    @todo = ToDo.find(params[:item])
    
    respond_to do |format|
      format.json { render :json  =>  {
            'id' => params[:item],
            'html'=> render_to_string(:partial => "admin/to_dos/edit_form.html.erb", :layout => false) 
        }  
      }
    end  
  end  
  
  def sortList
    item = ToDo.find(params[:item])
    
    item.to_do_list_id = params[:list] if item.to_do_list_id != params[:list]
    item.insert_at((params[:items].index item.id.to_s)+1)
    item.save
    
    respond_to do |format|
      format.js { render :text => "" }
    end
  end  
  
end  