class Admin::ToDoCommentsController < Admin::BaseController
    
    def new
      @todo = ToDo.find(params[:to_do_id])
      @comment = ToDoComment.new
    end  
    
    def create 
        comment = ToDoComment.new params[:to_do_comment]
        comment.user     = current_user
        comment.to_do_id = params[:to_do_id]  
        comment.save
        
        redirect_to admin_project_path(params[:project_id])
    end

end
