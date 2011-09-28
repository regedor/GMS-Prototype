class Admin::EventManageController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege

  def index
    setup_variables
  end
    
  def download
    setup_variables
    all_users = @event.users
    path = "#{RAILS_ROOT}/public/excel-file.xls"
    @event.create_excel_file path
    send_file path, :type=>"application/vnd.ms-excel"
  end    
    
  private
  
  def setup_variables
    @event = Event.find(params[:event_id])
    @users = @event.users.paginate(:page => params[:page], :per_page => 15)
  end    
    
end
