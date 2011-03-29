class Admin::CategoriesController < Admin::BaseController
# filter_access_to :index, :require => :read, :attribute_check => true, :load_method => lambda { Category.new :project_id => params[:project_id] }
  filter_access_to :show,  :require => :read, :attribute_check => true
  filter_access_to :index,:create,:new,:update,:edit,:delete,:destroy, :require => :manage, :attribute_check => true, :load_method => lambda {Category.new :project_id => params[:project_id]}
    #:load_method => lambda { Category.new :project_id => params[:project_id], :id => params[:id] }
 # filter_access_to :create,:new, :require => :create, :attribute_check => true, :load_method => lambda { Message.new }
 # filter_access_to :update,:edit, :require => :update, :attribute_check => true
 # filter_access_to :delete,:destroy, :require => :delete, :attribute_check => true
  
  before_filter :load_categories

  
  def new
    @record = Category.new
  end  
  

  def create
    @project = Project.find(params[:project_id])
    
    category = Category.new params[:category]
    category.project = @project
    if category.save
      respond_to do |format|
        format.json { render :json  =>  {
              'html'=> render_to_string(:partial => "admin/categories/category.html.erb", :layout => false, :locals => {:category => category, :project => @project}),
              'sidebar_html' => render_to_string(:partial => "admin/categories/sidebar.html.erb", :layout => false, :locals => {:categories => @project.categories})
          }  
        }
      end
    else
      flash[:error] = t("flash.categories_error")
      redirect_to new_admin_project_category_path(params[:project_id])  
    end  
    
    
  end


  def index
    @record = Category.new
    @project = Project.find(params[:project_id])
    @categories = @project.categories
  end
  
  def update
    @record = params[:record]
    category = Category.find(params[:id])
    category.project_id = params[:project_id]
    category.id = params[:id]
    category.name = @record[:name]
    category.save

    redirect_to admin_project_category_path(params[:project_id],params[:id])
  end  
  
  def destroy   
    record = Category.find(params[:id])
    record.destroy
    
    @project = Project.find(params[:project_id])
    
    respond_to do |format|
      format.json { render :json  => {
        'id' => params[:id], 
        'sidebar_html' => render_to_string(:partial => "admin/categories/sidebar.html.erb", :layout => false, :locals => {:categories => @project.categories})
        } 
      }
    end  
  end
  
  
  
  def show
    @category = Category.find(params[:id])
    @messages = @category.messages

    # for sidebar
  end

  protected

  def load_categories
    @categories = Project.find(params[:project_id]).categories
  end

end

