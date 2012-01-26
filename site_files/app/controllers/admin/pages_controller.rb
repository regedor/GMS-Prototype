class Admin::PagesController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege
  before_filter :group_hack, :only => [:update, :create]
  
  active_scaffold :page do |config|
    Scaffoldapp::active_scaffold config, "admin.pages",
      :list   => [ :title, :excert, :created_at, :total_approved_comments ],
      :show   => [  ],
      :create => [ :title, :body, :slug, :show_in_navigation, :has_comments, :priority, :show_announcements ],
      :edit   => [  ]
  end

  # Overrided this action to show revertion previews and revert option
  def show
    if params[:history_entry_id]
      @actual_record = Page.find params[:id] 
      @history_entry = HistoryEntry.find(params[:history_entry_id])
      @record        = @history_entry.historicable_preview
      render :action => 'show'
    else
      super
    end 
  end 
  
  def destroy
    page = Page.find(params[:id])
    if page.destroy
      flash[:notice] = t("flash.page_deleted",:page => page.title)
    else
      flash[:error] = t("flash.page_deletion_fail",:page => page.title)
    end
    
    redirect_to admin_pages_path
  end

  def preview
    @page = Page.build_for_preview(params[:record])
    respond_to do |format|
      format.js   { render :partial => 'preview', :locals => {:page => @page} }
    end
  end
  
  def group_hack
    params[:record][:group_id] = 0 if params[:record][:group_id].blank?
  end  
  
  def create
    page = Page.new params[:record]
    if page.save
      flash[:notice] = t("flash.page_created", :name => page.title)
      redirect_to admin_pages_path
    else
      @template.properly_show_errors(page)
      flash.now[:error] = t("flash.page_not_updated", :name => page.title)
    end
  end  
  
  def update
    @page = Page.find(params[:id])
    if @page.update_attributes params[:record]
      flash[:notice] = t("flash.page_updated", :name => @page.title)
      redirect_to admin_pages_path
    else  
      @template.properly_show_errors(page)
      flash.now[:error] = t("flash.page_not_updated", :name => @page.title) 
    end      
  end  

end
