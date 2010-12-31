class Admin::AnnouncementsController < Admin::BaseController

  active_scaffold :announcement do |config|

    Scaffoldapp::active_scaffold config, "admin.announcements", 
      :list         => [ :headline, :message, :starts_at, :ends_at ], 
      :show         => [ :headline, :message, :starts_at, :ends_at ],
      :create       => [ :starts_at, :ends_at, :headline, :message ],
      :edit         => [ ]
  end

end
