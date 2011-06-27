class Admin::UserOptionalGroupPicksController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege

  active_scaffold :user_optional_group_pick do |config|
    Scaffoldapp::active_scaffold config, "admin.user_optional_group_picks",
      :list     => [ :name, :role, :groups ],
      :show     => [ :name, :role, :groups ],
      :create   => [ :name, :role_id, :group_ids ],
      :edit     => [ ]
  end

end  
