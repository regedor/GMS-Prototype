class Admin::MessagesController < Admin::BaseController
  filter_access_to :index, :require => :read, :attribute_check => true, :load_method => lambda { Message.new :project_id => params[:project_id] }
  filter_access_to :show,  :require => :read, :attribute_check => true
  filter_access_to :create,:new, :require => :create, :attribute_check => true, :load_method => lambda { Message.new :project_id => params[:project_id]}
  filter_access_to :update,:edit, :require => :update, :attribute_check => true
  filter_access_to :delete,:destroy, :require => :delete, :attribute_check => true
  
  before_filter :load_categories  
  
  def new
    @record = Message.new
  end  
  

  def create
    message = Message.new params[:message]
    message.user = current_user
    message.project  = Project.find(params[:project_id])
    message.save  
    
    redirect_to admin_project_message_path(params[:project_id],message.id)
  end

  def index
    project= Project.find(params[:project_id])
    @messages = project.messages
    @categories = project.categories
  end

  def show
    @message = Message.find(params[:id])
    @comments = @message.messages_comments
    @creator = @message.user if @message.user
  end

  protected

  def load_categories
    @categories = Project.find(params[:project_id]).categories
  end
  
end

