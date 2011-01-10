class Admin::PagesController < Admin::BaseController
  active_scaffold :page do |config|
    Scaffoldapp::active_scaffold config, "admin.pages",
      :list   => [ :title, :excert, :created_at],
      :create => [ :title, :body, :slug ],
      :edit   => [  ]
  end

  def preview
    @page = Page.build_for_preview(params[:page])
    respond_to do |format|
      format.js { render :partial => 'pages/page.html.erb' }
    end
  end

end
