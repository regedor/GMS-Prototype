class Admin::GlobalCategoriesController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege
  cache_sweeper :global_category_sweeper, :only => [:update,:create,:destroy]
  
  active_scaffold :global_category do |config|
    Scaffoldapp::active_scaffold config, "admin.global_categories",
      :list   => [ :name ],
      :create => [ :name ],
      :edit   => [ ]
  end
  
  def set_category
    $current_category = GlobalCategory.find params[:option_id]
    respond_to do |format|
      format.js { render :text => "OK" }
    end
  end
  
  def create
    category = GlobalCategory.new params[:record]
    if category.save
      flash[:notice] = t('flash.global_category_created.successfully', :name => category.name)
      redirect_to admin_global_categories_path
    else
      flash.now[:error] = t('flash.global_category_created.error')
    end
  end
  
  def update
    category = GlobalCategory.find(params[:id])
    category.attributes = params[:record]
    if category.save
      flash[:notice] = t('flash.global_category_updated.successfully', :name => category.name)
      redirect_to admin_global_categories_path
    else
      flash.now[:error] = t('flash.global_category_updated.error')
    end
  end
  
  def destroy
    category = GlobalCategory.find(params[:id])
    if category.destroy
      flash[:notice] = t("flash.global_category_deleted",:name => category.name)
    else
      flash[:error] = t("flash.global_category_deletion_fail", :name => category.name)
    end
    
    redirect_to admin_global_categories_path
  end

  
end