class Mail < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================

  belongs_to :user

  # ==========================================================================
  # Validations
  # ==========================================================================


  # ==========================================================================
  # Attributes Accessors
  # ==========================================================================
  
  attr_accessor :mailable, :recipients
  attr_accessible :sent_on, :subject, :message, :user

  # ==========================================================================
  # Instance Methods
  # ==========================================================================
  
  def initialize
    super
    entities = []
    User.all.each do |user|
      entities << user.to_label
    end
    Group.all.each do |group|
      entities << group.name + I18n::t("admin.mails.group")
    end
    @mailable = entities.join(",")
    @recipients = []
  end 
  
  def set_xmls(just_users)
    self.xml_users = just_users.to_xml(:only=>[:name, :id, :email]) if just_users
    final_xml = "<entities>\n"
    if self.recipients
        self.recipients.each do |entity|
          case entity
            when User then final_xml +=  entity.to_xml(:skip_instruct => true, :only=>[:name, :id, :email])
            when Group then final_xml +=  entity.to_xml(:skip_instruct => true, :only=>[:name, :id])  
          end
        end  
      self.xml_groups_and_users = final_xml+"</entities>"
    end  
    
  end  
  

  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self
    
    def send_emails(users,mail)
      mail.sent_on = Time.now
      mail.set_xmls(users)
      mail.save!
      
      users.each do |user|
        begin 
          Notifier.deliver_mail(user,mail) 
        rescue Exception
          return false   #FIXME Do not fail if only one fails
        end
      end
      
      return true
    end  
    
  end
  
end
