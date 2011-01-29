class Admin::ToDoListsController < Admin::BaseController
  
  def index
    @lists = Project.find(params[:project_id]).to_do_lists
  end  
  
  def new
    @list = ToDoList.new
  end  
  
  def changeState
    todo = ToDo.find(params[:itemid])
    todo.done = (params[:state] == "done") ? true : false   
    todo.finished_date = Time.now
    todo.save
    
    @list = ToDoList.find(params[:id])
    
    respond_to do |format|
      format.json { render :json  =>  {
            'id' => params[:id],
            'html'=> render_to_string(:partial => "admin/to_do_lists/list.html.erb", :layout => false) 
        }  
      }
    end  
  end    
  
  def edit 
    @todo = ToDo.find(params[:id])
    
    respond_to do |format|
      format.json { render :json  =>  {
            'id' => params[:id],
            'html'=> render_to_string(:partial => "admin/to_dos/edit_form.html.erb", :layout => false) 
        }  
      }
    end  
  end  
  
  def cancel
    @todo = ToDo.find(params[:id])
    
    respond_to do |format|
      format.json { render :json  =>  {
            'id' => params[:id],
            'html'=> render_to_string(:partial => "admin/to_dos/cancel.html.erb", :layout => false) 
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