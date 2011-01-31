class Admin::MessagesController < Admin::BaseController
  #filter_access_to :all, :require => any_as_privilege
  


  active_scaffold :message do |config|
    Scaffoldapp::active_scaffold config, "admin.messages",
      :list   => [ :title, :user_id_show ],
      :show   => [ :title, :user_id_show ],
      :create => [ :title, :body ],
      :edit   => [ :title, :body, :category ]
  end

  def create
    message = Message.new
    record = params[:record]
    message.title = record[:title]
    message.user_id = current_user.id
    message.body = record[:body]
    message.project  = Project.find(params[:project_id])
    message.category_id = record[:category_id]
    message.save  
    
    redirect_to admin_project_message_path(params[:project_id],message.id)
  end

  def index
    @messages = Project.find(params[:project_id]).messages
  end

  def show
      @message = Message.find(params[:id])
      @comments = Message.find(params[:id]).messages_comments
  end

  
end

