class Admin::MailsController < Admin::BaseController 
  filter_access_to :all, :require => any_as_privilege
  
  def values
    vals = []
    User.all.each do |user|
       vals << {:label => user.name, :category => t("admin.mails.vals.users"), :value => "#{user.email}"}
    end  
    Group.all.each do |group|
      vals << {:label => group.name, :category => t("admin.mails.vals.groups"), :value => "group:#{group.name}"}
    end  
    
    respond_to do |format|
      format.json { render :json => vals.to_json }
    end
  end  
  
  def new
    @mail = Mail.new  
  end   
 
  def create
    recipients_array = params[:mail][:recipients_text].split(",")
    users_to_send = []
    @result = []
    users_and_groups = [] 
    mail = Mail.new
    recipients_array.reject!(&:blank?)
    recipients_array.each do |entity|
       if entity.match(/group:(\S*)/)
         group = Group.find_by_name(entity.match(/group:(\S*)/)[1])
         users_and_groups << group
         group.direct_users.each do |user|
           users_to_send << user
         end     
       else   
         user = User.find_by_email(entity)
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
