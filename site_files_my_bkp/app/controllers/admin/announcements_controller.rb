class Admin::AnnouncementsController < Admin::BaseController

  active_scaffold :announcement do |config|
    config.actions.swap :search, :live_search
    config.actions.exclude :update, :delete, :show
    config.actions << :show
    config.actions << :update
    config.actions << :delete
    config.actions << :delete

    config.create.columns = :starts_at, :ends_at, :headline, :message
    config.show.columns   = :headline, :message, :starts_at, :ends_at

    Scaffoldapp::active_scaffold config, "admin.announcements", [
      :headline, :message, :starts_at, :ends_at
    ]
  end

end
