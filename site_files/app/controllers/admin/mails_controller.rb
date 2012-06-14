class Admin::MailsController < Admin::BaseController 
  filter_access_to :all, :require => write_as_privilege
  filter_access_to [:index,:show], :require => [:as_read]
  
  active_scaffold :mail do |config|
      config.subform.columns = [:name]

      Scaffoldapp::active_scaffold config, "admin.mails",
        :list     => [ :sent_on, :subject, :message, :message_type ],
        :show     => [ :sent_on, :user_id, :xml_groups_and_users, :subject, :message, :message_type],
        :row_mark => [  ]
    end
  
  def values
    vals = []
    User.relevant(params[:q]).each do |user|
       vals << {:id => "u#{user.id}", :image => "#{@template.image_tag @template.avatar_url(user,:size => :small)}", :name => "#{user.name}" }
    end  
    Group.relevant(params[:q]).each do |group|
      vals << {:id => "g#{group.id}", :image => "#{@template.image_tag @template.avatar_url(group,:size => :small)}", :name => "#{group.name}" }
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
       if entity.match(/g(\S*)/)
         group = Group.find(entity.match(/g(\S*)/)[1])
         users_and_groups << group
         group.direct_users.each do |user|
           users_to_send << user
         end     
       else   
         user = User.find(entity.match(/u(\S*)/)[1])
         users_to_send << user
         users_and_groups << user
       end   
    end  
    users_to_send.uniq!    
    mail.recipients = users_and_groups
    mail.subject = params[:mail][:subject]
    mail.message = params[:mail][:message]
    mail.message_type = params[:mail][:message_type]
    mail.user_id = current_user.id
    mail.sent_on = Time.now
    mail.set_xmls(users_to_send)
    if mail.save
      (Mail.send_emails(users_to_send,mail)) ? flash[:notice] = t("admin.mails.send_ok") : flash[:error] = t("admin.mails.send_fail") 
      @mail = Mail.new 
      render :new
    else
      @mail = mail
      render :new
    end    
    
  end  
  
end  
