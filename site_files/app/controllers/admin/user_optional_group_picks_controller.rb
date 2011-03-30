class Admin::UserOptionalGroupPicksController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege

  active_scaffold :user_optional_group_pick do |config|
    Scaffoldapp::active_scaffold config, "admin.user_optional_group_picks",
      :list     => [ :name, :description, :groups ],
      :show     => [ :name, :description, :role, :group, :groups ],
      :create   => [ :name, :description, :role_id, :group_id, :group_ids ],
      :edit     => [ ]
  end

end  
