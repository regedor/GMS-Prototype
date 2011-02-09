class Admin::ToDoListsController < Admin::BaseController
  filter_access_to :all,
    :require         => :manage,
    :attribute_check => true,
    :load_method     => lambda { Project.find(params[:project_id]) }
  
  def index
    @project = Project.find(params[:project_id])
    @lists = @project.to_do_lists
    @reorder = params[:reorder] if params[:reorder]
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
    @project = Project.find(params[:project_id])
    
    respond_to do |format|
      format.json { render :json  =>  {
            'id' => params[:id],
            'html'=> render_to_string(:partial => "admin/to_do_lists/list.html.erb", :layout => false, :locals => {:list => @list, :project => @project}) 
        }  
      }
    end  
  end    
  
  def edit 
    @todo = ToDo.find(params[:id])
    @project = Project.find(params[:project_id])
    
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
            'html'=> render_to_string(:partial => "admin/to_dos/content.html.erb", :layout => false, :locals => {:todo => @todo}) 
        }  
      }
    end  
  end
  
  def sortList
    unless params[:reorder]
      item = ToDo.find(params[:item])
      
      item.to_do_list_id = params[:list] if item.to_do_list_id != params[:list]
      item.insert_at((params[:items].index item.id.to_s)+1)
      item.save
    else
      item = ToDoList.find(params[:item])
      
      item.insert_at((params[:list].index params[:item].to_s)+1)
      item.save
    end      
    
    respond_to do |format|
      format.js { render :text => "" }
    end
  end  
  
end  
