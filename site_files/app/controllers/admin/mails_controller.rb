class Admin::MailsController < Admin::BaseController 
  
  def index
    redirect_to :action=>"new"
  end  
  
  def new
    @mail = Mail.new  
  end  
 
  def create
    recipients_array = params[:mail][:recipients].split(" ,")
    users_to_send = []
    @result = []
    mail = Mail.new
    recipients_array.reject!(&:blank?)
    recipients_array.each do |entity|
       if entity.match(/(\S*) \(Group\)/)
         group = Group.find_by_name(entity.match(/(\S*) \(Group\)/)[1])
         group.direct_users.each do |user|
           users_to_send << user
         end     
       else    
         users_to_send << User.find_by_name(entity)
       end   
    end  
    users_to_send.uniq!
    mail.subject = params[:mail][:subject]
    mail.message = params[:mail][:message]
    mail.sent_on = Time.now
    mail.user    = current_user.id 
    @result = (Mail.send_emails(users_to_send,mail)) ? users_to_send.map(&:email) : "fail"
  end  
  
end  