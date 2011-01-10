class Admin::AnnouncementsController < Admin::BaseController
  active_scaffold :announcement do |config|
    Scaffoldapp::active_scaffold config, "admin.announcements",
      :list         => [ :title, :headline, :starts_at, :ends_at ],
      :show         => [ :title, :starts_at, :ends_at, :avatar, :headline, :message ],
      :create       => [ :title, :starts_at, :ends_at, :avatar, :headline, :message ],
      :edit         => [  ]
  end
end
