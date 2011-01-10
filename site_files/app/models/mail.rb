class Mail < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================

  belongs_to :user
  has_and_belongs_to_many :recipients, :class_name=>"User"

  # ==========================================================================
  # Validations
  # ==========================================================================


  # ==========================================================================
  # Attributes Accessors
  # ==========================================================================
  
  attr_accessor :mailable
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
  end 

  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self
    
    def send_emails(users,mail)
      mail.recipients = users
      mail.sent_on = Time.now
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
