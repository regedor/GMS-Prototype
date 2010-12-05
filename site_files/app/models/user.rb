class User < ActiveRecord::Base

  has_and_belongs_to_many :groups
  has_many :action_entries, :class_name => "ActionEntry", :foreign_key => "entity_id", 
   :conditions => "'action_entries'.'controller'='admin/users' AND 'action_entries'.'action' is not 'delete' "

  # Scope for non-deleted users
  named_scope :not_deleted, :conditions => {:deleted => false}

  ROLES = { :admin => 10, :user  => 1 }
  INVERTED_ROLES = ROLES.invert

  #is_gravtastic!
  acts_as_authentic do |c|
    c.openid_required_fields = [:fullname, :email, :language, :country, :nickname, 
                                'http://axschema.org/namePerson/first', 
                                'http://axschema.org/namePerson/last', 
                                'http://axschema.org/pref/language',
                                'http://axschema.org/contact/country/home',
                                'http://axschema.org/contact/email']
  end
 
  attr_accessible :email, :password, :password_confirmation, :openid_identifier, :language, :name, :gender, :country
  attr_accessible :row_mark #scaffold hack
  #####################
  ##  Relationships     
  #####################
  #

  #####################
  ##  Instance Methods
  #####################
  def active?
    active
  end

  def deleted?
    deleted
  end

  def activate!
    self.active = true 
    save
  end
  
  def deactivate!
    self.active = false 
    save
  end

  def delete!
    self.deleted = true
    save
  end
  
  def revive!
    self.deleted = false
    save
  end  

  def send_invitation!(mail)
    Notifier.deliver_invitation(self,mail)
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end

  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.deliver_password_reset_instructions(self)  
  end  

  def set_role!(role)
    self.role = ROLES[role]
    self.save!
  end

  def is_role?(role)
    self.role == ROLES[role]
  end

  def role_sym
    INVERTED_ROLES[self.role]
  end

  def first_name
    name.split(" ").first
  end
  
  def revertTo(xmlUser)
    user_hash = Hash.from_xml(xmlUser)
    self.update_attributes user_hash["user"]
   # self.attributes = user_hash["user"] #FIXME Doesn't work... :S
  end  
  
  def self.revive_by_ids(ids)
    ids.each do |id|
      return false unless User.find(id).revive!
    end 
    return true
  end  
  
  def self.destroy_by_ids(ids)
    ids.each do |id|
      return false unless User.find(id).delete!
    end 
    return true 
  end
  
  def self.activate!(ids)
    ids.each do |id|
      return false unless User.find(id).activate!
    end 
    return true
  end  
  
  def self.deactivate!(ids)
    ids.each do |id|
      return false unless User.find(id).deactivate!
    end 
    return true
  end

 private
  def  map_openid_registration(registration)
    self.email     = registration['email']    unless registration['email'].blank?
    self.name      = registration['fullname'] unless registration['fullname'].blank?
    self.nickname  = registration['nickname'] unless registration['nickname'].blank?
    self.language  = registration['language'] if UserSession::LANGUAGES.map(&:last).include? registration['language']
    self.country   = registration['country']  unless registration['country'].blank?
    if registration['http://axschema.org/contact/email']
      self.email    = registration['http://axschema.org/contact/email'].to_s
      self.name     = registration['http://axschema.org/namePerson/first'].to_s + 
                      registration['http://axschema.org/namePerson/last'].to_s
      self.language = registration['http://axschema.org/pref/language'].to_s if UserSession::LANGUAGES.map(&:last).include? registration['language']
      self.country  = registration['http://axschema.org/contact/country/home'].to_s
    end
  end

end
