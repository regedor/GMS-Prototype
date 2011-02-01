class Admin::UserOptionalGroupPicksController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege
  
  active_scaffold :user_optional_group_pick do |config|

    config.columns[:role].form_ui = :select
    config.columns[:group].form_ui = :select
    config.columns[:groups].form_ui = :select
    config.columns[:groups].options = {:draggable_lists => true}
    
    Scaffoldapp::active_scaffold config, "admin.user_optional_group_picks",
      :list     => [ :name, :description ],
      :show     => [ :name, :description, :role, :group, :groups ],
      :create   => [ :name, :description, :role, :group, :groups ],
      :edit     => [ ]
  end

end  
