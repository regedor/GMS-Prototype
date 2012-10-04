class Admin::UsersController < Admin::BaseController
  filter_access_to :all, :require => write_as_privilege
  filter_access_to [:index,:show], :require => [:as_read]

  before_filter :load_groups, :only => :index

  active_scaffold :user do |config|
    
    group_actions = Group.find_all_by_show_in_user_actions(true).map do |group|
      group = [ { :method => "add_to_group_#{group.id}", :name => group.name },
                { :method => "remove_from_group_#{group.id}", :name => group.name } ]
    end.flatten 
 
    Scaffoldapp::active_scaffold config, "admin.users", 
      :list         => [ :created_at, :email, :active, :name, :role ], 
      :show         => [ :email, :active, :nickname, :profile, :website, :country, :gender ],
      :edit         => [ :email, :active, :nickname, :profile, :website, :country, :gender, :group_ids, :role_id, :avatar, 
                         :phone, :role, :name, :address, :id_number ],
      :actions_list => [ :delete_by_ids!, :activate!, :deactivate! ].concat(group_actions)
  end

  # Override this method to define conditions to be used when querying a recordset (e.g. for List).
  # With this, only the users with the value 'false' in the column 'deleted' will be shown.
#  def conditions_for_collection
#    return { :deleted => false }
#  end

  def custom_finder_options
    return { :joins => 'INNER JOIN groups_users ON users.id = groups_users.user_id',
             :conditions => { 'groups_users.group_id' => params[:group] }
           } if params[:group]
    return { }
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
  
  def update
    positions = params[:record].delete(:positions) if params[:record][:positions]
    current_user.delete_positions(params[:record][:group_ids])

    if current_user.update_attributes params[:record]
      positions[:groups].each_with_index do |group_id,idx|
        prev_position = Position.find_by_user_id_and_group_id(current_user.id,group_id.to_i)

        if prev_position
          prev_position.update_attributes({:name => positions[:names][idx]})
        else
          Position.create(:user_id => current_user.id, :group_id => group_id.to_i, :name => positions[:names][idx])
        end
      end if positions

      render :json => "/admin/users".to_json
    else
      render :json => "fail", :status => 500
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
  
  def positions
    user = User.find params[:id]

    if params[:group_id] and not user.group_ids.include? params[:group_id].to_i
      groups = nil
      positions = nil
    else
      groups = (params[:group_id]) ? [Group.find(params[:group_id])] : user.groups
      positions = (params[:group_id]) ? 
        [Position.find_by_user_id_and_group_id(user.id, params[:group_id])] : 
        fetch_positions_from_groups(user.group_ids,user)
    end

    respond_to do |format|
      format.json { render :json => {'groups' => groups, 'positions' => positions}}
    end
  end
  
  private

    def load_groups
      @groups = Group.all(:order => :name)
    end
    
    def fetch_positions_from_groups(group_ids,user)
      group_ids.inject([]) do |res, group_id|
        res << Position.find_by_user_id_and_group_id(user.id, group_id)
      end
    end
end
