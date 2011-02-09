class Admin::MessagesCommentsController < Admin::BaseController
    filter_access_to :all, :require => :create, :attribute_check => true, :load_method => lambda {Message.find(params[:message_id])}
    
    def create 
        record = params[:record]
        comment = MessagesComment.new
        comment.message_id = record[:message_id]
        comment.user_id = current_user
        comment.body = record[:body]
        comment.save
        
        redirect_to admin_project_message_path(params[:project_id], record[:message_id])
    end

end
