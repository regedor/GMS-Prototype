class User < ActiveRecord::Base

  # ==========================================================================
  # Relationships
  # ==========================================================================
  
  has_and_belongs_to_many :groups
  belongs_to              :role
  has_many :action_entries, :class_name => "ActionEntry", :foreign_key => "entity_id", 
   :conditions => "'action_entries'.'controller'='admin/users' AND 'action_entries'.'action' is not 'delete' "


  # ==========================================================================
  # Validations
  # ==========================================================================
  
  validates_presence_of   :language, :name

  # ==========================================================================
  # Extra defnitions
  # ==========================================================================

  #is_gravtastic!
  acts_as_authentic do |c| 
    c.openid_required_fields = [
      :fullname, :email, :language, :country, :nickname, 
      'http://axschema.org/namePerson/first', 
      'http://axschema.org/namePerson/last', 
      'http://axschema.org/pref/language',
      'http://axschema.org/contact/country/home',
      'http://axschema.org/contact/email'
    ]
  end
 
  attr_accessible :email, :password, :password_confirmation, :openid_identifier
  attr_accessible :language, :name, :gender, :country
  attr_accessible :groups
  attr_accessible :row_mark #scaffold hack

  # Scope for non-deleted users
  named_scope :not_deleted, :conditions => {:deleted => false}

  # ==========================================================================
  # Instance Methods
  # ==========================================================================

  def to_label
    "#{self.name} < #{self.email} >"
  end

  #DELETE ME
  def build_cached_groups!
    groups = self.all_groups
    roles = group && group.roles
    roles = self.groups.map(&:roles) unless roles && !roles.empty?
    roles.map { |role| role.name.underscore }
    self.cached_roles = roles.join ", "
    self.save
  end

  def role_sym
    [ self.role.label.to_sym ]
  end

  def authorized_for?(*args)
    !self.deleted
  end

  def activate!
    self.active = true 
    save
  end
  
  def deactivate!
    self.active = false 
    save
  end

  def active?
    self.active
  end

  def delete!
    self.deleted = true
    save
  end
  
  def undelete!
    self.deleted = false
    save
  end  

  def deleted?
    self.deleted
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

  def has_role?(role)
    self.role == ROLES[role]
  end

  def first_name
    self.name.split(" ").first
  end

  def small_name
    self.nickname || first_name
  end
  
  def revertTo(xmlUser)
    user_hash = Hash.from_xml(xmlUser)
    self.update_attributes user_hash["user"]
   # self.attributes = user_hash["user"] #FIXME Doesn't work... :S
  end  
  
 
  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self
    def undelete_by_ids!(ids)
      ids.each do |id|
        return false unless User.find(id).revive!
      end 
      return true
    end  
    
    def delete_by_ids!(ids)
      ids.each do |id|
        return false unless User.find(id).delete
      end 
      return true 
    end
    
    def activate!(ids)
      ids.each do |id|
        return false unless User.find(id).activate!
      end 
      return true
    end  
    
    def deactivate!(ids)
      ids.each do |id|
        return false unless User.find(id).deactivate!
      end 
      return true
    end
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
