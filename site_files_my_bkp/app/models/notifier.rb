class Notifier < ActionMailer::Base
  def activation_instructions(user)
    setup_email(user)
    @subject += I18n.translate 'notifier.activation_instructions.subject'
    @body[:account_activation_url]  = activate_url(user.perishable_token)
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
   
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "info@regedor.com"
      @subject     = "[Regedor] "
      @sent_on     = Time.now
      @body[:user] = user
      I18n.locale  = user.language
    end
end
