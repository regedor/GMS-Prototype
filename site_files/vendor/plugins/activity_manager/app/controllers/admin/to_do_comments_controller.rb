class Admin::ToDoCommentsController < Admin::BaseController
    
    def new
      @todo = ToDo.find(params[:to_do_id])
      @comment = ToDoComment.new
      @project = Project.find(params[:project_id])
    end  
    
    def create 
        comment = ToDoComment.new params[:to_do_comment]
        comment.user     = current_user
        comment.to_do_id = params[:to_do_id]  
        if comment.save
          if params[:to_do_comment][:users].map(&:blank?).member? true
            mail = Mail.create(:message => comment.to_do.description, :sent_on => Time.now, :subject => "")

            begin
              params[:to_do_comment][:users].reject(&:blank?).each do |user_id|
                user = User.find(user_id)
                Notifier.deliver_to_do_notification(user,mail)
              end  
            rescue Exception
              return false
            end
          end       
        else
          flash[:error] = t("flash.to_do_comment_creation_fail")
        end
           
        redirect_to admin_project_path(params[:project_id])
    end
    
    def preview
      @comment = ToDoComment.build_for_preview(params[:to_do_comment])
      
      respond_to do |format|
        format.js {
          render :partial => 'preview', :locals => {:comment => @comment}
        }
      end
      
    end  

end
