class Admin::PagesController < Admin::BaseController
  active_scaffold :page do |config|
    Scaffoldapp::active_scaffold config, "admin.pages",
      :list   => [ :title, :excert, :created_at, :total_approved_comments ],
      :create => [ :title, :body, :slug, :show_in_navigation, :has_comments ],
      :edit   => [  ]
  end

  def preview
    @page = Page.build_for_preview(params[:record])
    respond_to do |format|
      format.js { render :partial => 'pages/page.html.erb' }
    end
  end

end
