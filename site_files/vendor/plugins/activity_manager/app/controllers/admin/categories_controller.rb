class Admin::CategoriesController < Admin::BaseController
# filter_access_to :index, :require => :read, :attribute_check => true, :load_method => lambda { Category.new :project_id => params[:project_id] }
  filter_access_to :show,  :require => :read, :attribute_check => true, :load_method => lambda { Category.new :project_id => params[:project_id] }
 # filter_access_to :create,:new, :require => :create, :attribute_check => true, :load_method => lambda { Message.new }
 # filter_access_to :update,:edit, :require => :update, :attribute_check => true
 # filter_access_to :delete,:destroy, :require => :delete, :attribute_check => true
  
  
  
  def new
    @record = Category.new
  end  
  

  
  
  def create
    category = Category.new params[:category]
    category.project_id = params[:project_id]
    category.save
    
    redirect_to admin_project_path(params[:project_id])
  end


  def index
    @categories = Project.find(params[:project_id]).categories
    @project = Project.find(params[:project_id])
  end
  
  def update
    @record = params[:record]
    category = Category.find(params[:id])
    category.project_id = params[:project_id]
    category.id = params[:id]
    category.name = @record[:name]
    category.save

    redirect_to admin_project_category_path(params[:id])
  end  
  
  def destroy
    
   @record = Category.find(params[:id])
   @record.destroy

   redirect_to admin_project_categories_path
    
  end
  
  
  
  def show
    @category = Category.find(params[:id])
    @messages = @category.messages

    # for sidebar
    @categories = Project.find(params[:project_id]).categories
  end
  
 # def destroy
 #   category = Category.find(params[:id])
 #   category.destroy
 # end

  
end

