class Admin::CommentsController < Admin::BaseController

  active_scaffold :comments do |config|
    config.actions.swap :search, :live_search
    config.actions.exclude :create, :update, :delete, :show
    config.actions << :update
    config.actions << :delete

    config.update.columns = :author, :author_url, :author_email, :body

    Scaffoldapp::active_scaffold config, "admin.comments", [
      :created_at, :commenter, :excert, :post
    ]
  end

  # Override this method to define conditions to be used when querying a recordset (e.g. for List).
  # With this, only the comments with the value 'false' in the column 'deleted' will be shown.
  def conditions_for_collection
    return { :deleted => false }
  end

end
