class Admin::EventManageController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege

  def index
    @event = Event.find(params[:event_id])
    @users = @event.users.paginate(:page => params[:page], :per_page => 2)
  end
    
  def download
    @event = Event.find(params[:event_id])
    all_users = @event.users
    @users = all_users.paginate(:page => params[:page], :per_page => 2)
    
    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => 'Subscribed Users'
    sheet.row(0).concat ["Name", "E-Mail"]
    all_users.each_index do |index|
      user = all_users[index]
      sheet.row(index+1).concat [user.name,user.email]
    end  
    book.write "#{RAILS_ROOT}/public/excel-file.xls"
    send_file "#{RAILS_ROOT}/public/excel-file.xls", :type=>"application/vnd.ms-excel"
    #redirect_to :action => 'index', :controller => 'admin/event_manage'
  end    
    
end
