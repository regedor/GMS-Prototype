class Admin::GroupsController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege
  after_filter :save_associations, :only => [ :create, :update ]

  active_scaffold :group do |config|
    Scaffoldapp::active_scaffold config, "admin.groups",
      :list         => [ :name, :mailable, :description ],
      :show         => [ :name, :description, :mailable, :direct_users],
      :create       => [ :name, :description, :mailable, :user_choosable, :groups, :direct_users ],
      :edit         => [ :name, :description, :mailable, :user_choosable, :groups, :direct_users ],
      :actions_list => [ :delete_by_ids! ]
  end

  protected

    # Active Scaffold hack
    # AS is not saving the associated records (reason unknown)
    # In conjunction with the after filter it saves the associated records
    # Associations are saved after the validations (a better hack is necessary in case there are validations)
    def save_associations
      @record.group_ids       = params[:record][:group_ids]
      @record.direct_user_ids = params[:record][:direct_user_ids]
    end

end
