class Admin::GroupsController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege
  before_filter :date_localization, :only => [ :create, :update ]
  after_filter  :save_associations, :only => [ :create, :update ]

  active_scaffold :group do |config|
    Scaffoldapp::active_scaffold config, "admin.groups",
      :list         => [ :name, :mailable, :description ],
      :show         => [ :name, :description, :mailable, :direct_users],
      :create       => [ :name, :description, :mailable, :user_choosable, :groups, :direct_users, :behavior_at_time, :behavior_after_time, :behavior_file_name ],
      :edit         => [  ],
      :actions_list => [ :delete_by_ids! ]
  end

  def do_edit
    super
    if params[:action] == 'edit'
      @record.behavior_type = 'at_time'    if @record.behavior_at_time
      @record.behavior_type = 'after_time' if @record.behavior_after_time
    else
      @record.behavior_type = params[:record][:behavior_type]
    end
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

    def date_localization
      unless params[:record][:behavior_at_time].blank?
        begin
          params[:record][:behavior_at_time] = DateTime.strptime(params[:record][:behavior_at_time],"%d/%m/%Y").to_time
        rescue ArgumentError
          flash[:error] = t("flash.invalid_date")
          redirect_to :action => params[:action]
          return
        end
      end
    end 

end
