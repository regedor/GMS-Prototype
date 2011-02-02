class Admin::GroupsController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege
  
  active_scaffold :group do |config|
    config.subform.columns = [:name]
   
    config.columns[:groups].form_ui = :select
    config.columns[:groups].options = {:draggable_lists => true}
    config.columns[:direct_users].form_ui = :select 
    config.columns[:direct_users].options = {:draggable_lists => true}
    
    Scaffoldapp::active_scaffold config, "admin.groups",
      :list     => [ :name, :mailable, :description ],
      :show     => [ :name, :description, :mailable, :direct_users],
      :create   => [ :name, :description, :mailable, :user_choosable, :groups, :direct_users ],
      :edit     => [ :name, :description, :mailable, :user_choosable, :groups, :direct_users ],
      :row_mark => [ :delete_by_ids ]
  end

end  
