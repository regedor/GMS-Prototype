class Admin::AnnouncementsController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege

  active_scaffold :announcement do |config|
    Scaffoldapp::active_scaffold config, "admin.announcements",
      :list         => [ :title, :message, :starts_at, :ends_at, :url ],
      :show         => [ :title, :starts_at, :ends_at, :url, :avatar, :message ],
      :create       => [ :title, :starts_at, :ends_at, :url, :avatar, :message ],
      :edit         => [  ]
  end

  def do_new
    super
    @record[:starts_at] = Time.now
  end
end
