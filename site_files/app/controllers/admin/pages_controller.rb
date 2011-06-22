class Admin::PagesController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege

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

  def preview
    @page = Page.build_for_preview(params[:record])
    respond_to do |format|
      format.js   { render :partial => 'preview' }
    end
  end

end
