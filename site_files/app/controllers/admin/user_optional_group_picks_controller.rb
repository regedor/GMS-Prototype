class Admin::UserOptionalGroupPicksController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege
  after_filter :save_associations, :only => [ :create, :update ]

  active_scaffold :user_optional_group_pick do |config|
    Scaffoldapp::active_scaffold config, "admin.user_optional_group_picks",
      :list     => [ :name, :description, :groups ],
      :show     => [ :name, :description, :role, :group, :groups ],
      :create   => [ :name, :description, :role, :group, :groups ],
      :edit     => [ ]
  end

  protected

    # Active Scaffold hack
    # AS is not saving the associated records (reason unknown)
    # In conjunction with the after filter it saves the associated records
    # Associations are saved after the validations (a better hack is necessary in case there are validations)
    def save_associations
      @record.role_id   = params[:record][:role_id]
      @record.group_id  = params[:record][:group_id]
      @record.save
      @record.group_ids = params[:record][:group_ids]
    end

end  
