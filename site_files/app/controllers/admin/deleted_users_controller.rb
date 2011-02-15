class Admin::DeletedUsersController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege

  active_scaffold :deleted_user do |config|
  
    Scaffoldapp::active_scaffold config, "admin.deleted_users", 
      :list         => [ :created_at, :email, :active, :name, :role ], 
      :show         => [ :email, :active, :nickname, :profile, :website, :country, :gender ],
      :actions_list => [ :destroy_by_ids!, :undelete_by_ids ]

      config.action_links.add 'undelete', :type => :member, :page => true, :crud_type => :delete, :method => :put,
                                          :confirm => :are_you_sure_to_undelete,
                                          :label => I18n::t("admin.deleted_users.index.undelete_link")
  end

  # Override this method to define conditions to be used when querying a recordset (e.g. for List).
  # With this, only the users with the value 'false' in the column 'deleted' will be shown.
  def conditions_for_collection
    return { :deleted => true }
  end

  # Overrided this action to show revertion previews and revert option
  def show
    if params[:history_entry_id]
      @actual_record = DeletedUser.find params[:id] 
      @history_entry = HistoryEntry.find(params[:history_entry_id])
      @record        = @history_entry.historicable_preview
    else
     super   
    end
  end

  def undelete
    user = DeletedUser.find params[:id]
    if request.method == :put
      user.undelete!
      flash[:notice]=t('flash.user_successfully_undeleted')
      redirect_to admin_deleted_users_path
    end
  end
  
end

