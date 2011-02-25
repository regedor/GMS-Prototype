class Mail < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================

  belongs_to :user
#  validates_presence_of :message_type

  # ==========================================================================
  # Validations
  # ==========================================================================
  
  validates_presence_of :recipients

  # ==========================================================================
  # Attributes Accessors
  # ==========================================================================
  
  attr_accessor :mailable, :recipients, :recipients_text
  attr_accessible :sent_on, :subject, :message, :user, :message_type

  # ==========================================================================
  # Instance Methods
  # ==========================================================================
  
  def initialize(*args)
    super(*args)
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
  
    def format_phone_number(number,country)
      if(number[0..0] == "+")
        number = number[1..-1]
      end
      if(number[0..1] == "00")
        number = number[2..-1]
      end
      if(country=="PT")
        if(number[0..2] != "351")
          number = "351"+number
        end
      end
      number
    end
    
    def send_emails(users,mail)
      if(mail.message_type == "email")
        users.each do |user|
          begin 
            Notifier.deliver_mail(user,mail) 
          rescue Exception
            return false   #FIXME Do not fail if only one fails
          end
        end
      elsif(mail.message_type == "sms")
        list = []
        users.each do |user|
          if user.country
            list << format_phone_number(user.phone,user.country)
          end
        end
       begin
          api = Clickatell::API.authenticate(configatron.clickatell.api_id, 
                                             configatron.clickatell.username, 
                                             configatron.clickatell.password,
                                             :from => configatron.site_name)
          api.send_message(list, mail.subject+"\n"+mail.message)
          puts("---------------------------- SMS \n Clickatell Account Balance: " + api.account_balance)
        rescue Exception
          return false   #FIXME Do not fail if only one fails
        end
      end
      
      return true
    end  
    
  end
  
end
