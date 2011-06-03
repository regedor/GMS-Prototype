class Admin::AnnouncementsController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege

  before_filter :date_localization, :only => [ :create, :update ]
  before_filter :validate_data, :only => [ :create, :update ]

  active_scaffold :announcement do |config|
    Scaffoldapp::active_scaffold config, "admin.announcements",
      :list         => [ :title, :starts_at, :ends_at, :url ],
      :show         => [ :title, :starts_at, :ends_at, :url, :avatar, :message ],
      :create       => [ :title, :starts_at, :ends_at, :url, :avatar, :message, :priority ],
      :edit         => [  ]
  end

  def do_new
    super
    @record[:starts_at] = Time.now
  end

  protected

    def validate_data
      if params[:record][:has_message].size == 1
        params[:record][:has_message] = false
      else
        params[:record][:has_message] = true
      end
    end

    def date_localization
      begin
        [:starts_at, :ends_at].each do |attribute|
          params[:record][attribute] = DateTime.strptime(params[:record][attribute], "%d/%m/%Y %H:%M").to_time if params[:record][attribute]
        end
      rescue ArgumentError
        flash[:error] = t("flash.invalid_date")
        redirect_to :action => params[:action] == 'create' ? 'new' : 'edit'
        return
      end
    end
end
