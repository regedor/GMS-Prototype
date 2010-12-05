class Admin::CommentsController < Admin::BaseController

  active_scaffold :comments do |config|
    config.actions.swap :search, :live_search
    config.actions.exclude :create, :update, :delete, :show
    config.actions << :update
    config.actions << :delete

    config.update.columns = :author, :author_url, :author_email, :body

    Scaffoldapp::active_scaffold config, "admin.comments", [
      :commenter, :excert, :created_at
    ]

  end

  def list
    active_scaffold_config.list.label =
                           I18n::t 'admin.comments.index.title',
                                   :title => (Post.find params[:post_id]).title
    super
  end

end
