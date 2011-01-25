class Admin::UsersController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege

  active_scaffold :user do |config|
    config.subform.columns = [:email] 

    config.columns[:groups].show_blank_record = false

    config.columns[:role].form_ui = :select 
    config.columns[:groups].form_ui = :select 
    config.columns[:groups].options = {:draggable_lists => true}
  
    Scaffoldapp::active_scaffold config, "admin.users", 
      :list         => [ :created_at, :email, :active, :name, :role ], 
      :show         => [ :email, :active, :nickname, :profile, :website, :country, :gender ],
      :edit         => [ :email, :active, :nickname, :profile, :website, :country, :gender, :groups, :role ],
      :actions_list => [ :destroy_by_ids, :activate!, :deactivate! ]
  end

  # Override this method to define conditions to be used when querying a recordset (e.g. for List).
  # With this, only the users with the value 'false' in the column 'deleted' will be shown.
  def conditions_for_collection
    return { :deleted => false }
  end

  def do_destroy
    @record = find_if_allowed(params[:id], 'delete')
    if request.method == :delete
      begin
        self.successful = @record.delete!
      rescue
        flash[:warning] = as_(:cant_destroy_record, user.to_label)
        self.successful = false
      end
    end
  end

  # Overrided this action to show revertion previews and revert option
  def show
    if params[:history_entry_id]
      @actual_record = User.find params[:id] 
      @history_entry = HistoryEntry.find(params[:history_entry_id])
      @record        = @history_entry.historicable_preview
    else
     super   
    end
  end
  
end
