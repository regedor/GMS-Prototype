class Admin::CommentsController < Admin::BaseController

  active_scaffold :comments do |config|
    config.actions.swap :search, :live_search
    config.actions.exclude :update, :delete, :show
    config.actions << :update
    config.actions << :delete

    config.update.columns = :author, :author_url, :author_email, :body
    config.create.columns = :author, :author_url, :author_email, :body

    Scaffoldapp::active_scaffold config, "admin.comments", [
      :created_at, :commenter, :excert, :post
    ], true
  end

end
