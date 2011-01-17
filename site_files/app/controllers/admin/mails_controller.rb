class Admin::MailsController < Admin::BaseController 
  filter_access_to :all, :require => any_as_privilege
  
  active_scaffold :mail do |config|
    config.subform.columns = [:name]
   
    Scaffoldapp::active_scaffold config, "admin.mails",
      :list     => [ :sent_on, :subject, :message ],
      :show     => [ :sent_on, :user_id, :xml_groups_and_users, :subject, :message],
      :row_mark => [  ]
  end
  
  def new
    @mail = Mail.new  
  end   
 
  def create
    recipients_array = params[:mail_to].split(",")
    users_to_send = []
    @result = []
    users_and_groups = [] 
    mail = Mail.new
    recipients_array.reject!(&:blank?)
    recipients_array.each do |entity|
       if entity.match(/(\S*) \(Group\)/)
         group = Group.find_by_name(entity.match(/(\S*) \(Group\)/)[1])
         users_and_groups << group
         group.direct_users.each do |user|
           users_to_send << user
         end     
       else   
         user = User.find_by_email(entity.match(/\S* < (\S*) >/)[1])
         users_to_send << user
         users_and_groups << user
       end   
    end  
    users_to_send.uniq!
    mail.recipients = users_and_groups
    mail.subject = params[:mail][:subject]
    mail.message = params[:mail][:message]
    mail.user_id = current_user.id
    @result = (Mail.send_emails(users_to_send,mail)) ? users_to_send.map(&:email) : "fail"
  end  
  
end  
