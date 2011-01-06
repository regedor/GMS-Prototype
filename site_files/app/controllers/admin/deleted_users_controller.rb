class Admin::DeletedUsersController < Admin::BaseController
#  filter_access_to :all, :require => any_as_privilege #FIXME: uncomment this line

  active_scaffold :user do |config|
    config.subform.columns = [:email]

    config.columns[:groups].show_blank_record = false

    config.columns[:role].form_ui = :select 
    config.columns[:groups].form_ui = :select 
    config.columns[:groups].options = {:draggable_lists => true}
  
    Scaffoldapp::active_scaffold config, "admin.deleted_users", 
      :list         => [ :created_at, :email, :active, :name, :role ], 
      :show         => [ :email, :active, :nickname, :profile, :website, :country, :gender ],
      :edit         => [ :email, :active, :nickname, :profile, :website, :country, :gender, :groups, :role ],
      :actions_list => [ :destroy_by_ids, :activate!, :undelete_by_ids ]

      config.action_links.add 'undelete', :type => :member, :page => true, :crud_type => :delete, :method => :put,
                                          :confirm => :are_you_sure_to_delete,
                                          :label => I18n::t("admin.deleted_users.index.undelete_link")
  end

  # Override this method to define conditions to be used when querying a recordset (e.g. for List).
  # With this, only the users with the value 'false' in the column 'deleted' will be shown.
  def conditions_for_collection
    return { :deleted => true }
  end

  # I are Overriding this action to use it as befor revert preview too
  def show
    if params[:history_entry_id]
      @actual_record = User.find params[:id] 
      @history_entry  = HistoryEntry.find(params[:history_entry_id])
      @record         = @history_entry.historicable_preview
    else
     super   
    end
  end

  def undelete
    user = User.find params[:id]
    if request.method == :put
      user.undelete!
      flash[:notice]=t('flash.user_successfully_undeleted')
      redirect_to admin_deleted_users_path
    end
  end
end

