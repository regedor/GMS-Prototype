class Admin::GroupsController < Admin::BaseController
  filter_access_to :all, :require => write_as_privilege
  filter_access_to [:index,:show], :require => [:as_read]
  before_filter :date_localization, :only => [ :create, :update ]

  active_scaffold :group do |config|
    Scaffoldapp::active_scaffold config, "admin.groups",
      :list         => [ :name, :mailable, :description ],
      :show         => [ :name, :description, :mailable, :direct_users],
      :create       => [ :name, :description, :mailable, :user_choosable, :group_ids, :direct_user_ids, :behavior_at_time, :behavior_after_time, :behavior_file_name, :behavior_group_to_jump_id ],
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

    def date_localization
      unless params[:record][:behavior_at_time].blank?
        begin
          params[:record][:behavior_at_time] = DateTime.strptime(params[:record][:behavior_at_time],"%d/%m/%Y").to_time
        rescue ArgumentError
          flash[:error] = t("flash.invalid_date")
          redirect_to :action => params[:action] == 'create' ? 'new' : 'edit'
          return
        end
      end
    end 

end
