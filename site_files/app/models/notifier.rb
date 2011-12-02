class Notifier < ActionMailer::Base
  def activation_instructions(user)
    setup_email(user)
    @subject += I18n.translate 'notifier.activation_instructions.subject'
    @body[:account_activation_url]  = user_activate_url(user.perishable_token)
  end
  
  def activation_confirmation(user)
    setup_email(user)
    @subject += I18n.translate 'notifier.activation_confirmation.subject' 
    @body[:root_url]  = root_url
  end
 
  def password_reset_instructions(user)  
    setup_email(user)
    @subject += I18n.translate 'notifier.password_reset_instructions.subject'  
    @body[:url] = edit_user_password_reset_url(user.perishable_token)  
  end  

  def invitation(user,mail)  
    setup_email(user)
    @recipients  = mail
    @subject += I18n.translate 'notifier.invitation.subject'  
    @body[:user] = user  
    @body[:root_url]  = root_url
  end  
   
  def mail(user,mail)
    setup_email(user)
    @from     = mail.user.name
    @subject += mail.subject
    @body[:message] = mail.message  
  end
  
  def new_to_do_notification(user,mail)
    setup_email(user)
    @subject += mail.subject
    divided = mail.message.split("&sep&")
    @body[:sender] = divided[0]
    @body[:receiver] = user.name unless user.name.blank?
    todo = ToDo.find(divided[1])
    @body[:todo] = todo.description
    @body[:list] = todo.to_do_list.name
    @body[:link] = admin_project_to_do_comments_url(todo.to_do_list.project.id,todo.id)
    @body[:date] = I18n::localize(todo.due_date, :format => :medium) if todo.due_date
  end  
  
  def update_to_do_notification(user,mail)
    setup_email(user)
    @subject += mail.subject
    divided = mail.message.split("&sep&")
    @body[:sender] = divided[0]
    @body[:todo] = divided[1]
    @body[:list] = divided[2]
  end
  
  def to_do_notification(user,mail)
    setup_email(user)
    @subject += mail.subject
    divided = mail.message.split("&sep&")
    @body[:sender] = divided[0]
    @body[:todo] = divided[1]
  end     
   
  protected
    def setup_email(user)
      @recipients  = user.email
      @from        = configatron.mailer_email
      @subject     = "[#{configatron.site_name}] "
      @sent_on     = Time.now
      @body[:user] = user
      I18n.locale  = user.language
    end
end
