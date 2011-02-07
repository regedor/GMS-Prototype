class User < ActiveRecord::Base

  # ==========================================================================
  # Relationships
  # ==========================================================================

  has_many   :groups_users  
  has_many   :groups, :through => :groups_users
  belongs_to :role


  # ==========================================================================
  # Validations
  # ==========================================================================
  
  validates_presence_of   :language
  validates_format_of     :phone,
    :message => "must be a valid telephone number.", 
    :with => /(^[\(\)0-9\- \+\.]{9,20} *[extension\.]{0,9} *[0-9]{0,5}$)|(^$)/i #FIXME i18n


  # ==========================================================================
  # Attributes Accessors
  # ==========================================================================

  attr_accessible  :email               
  attr_accessible  :name                
  attr_accessible  :password
  attr_accessible  :password_confirmation
  attr_accessible  :nickname            
  attr_accessible  :gender              
  attr_accessible  :profile             
  attr_accessible  :website             
  attr_accessible  :country             
  attr_accessible  :phone               
  attr_accessible  :emails #does user want to recieve emails 
  attr_accessible  :language            
  attr_accessible  :openid_identifier   
  attr_accessible  :groups
  attr_accessible  :role                
  attr_accessible  :row_mark #scaffold hack


  # ==========================================================================
  # Extra definitions
  # ==========================================================================

  #is_gravtastic!
  
  # Makes this model historicable
  include HistoryEntry::Historicable

  # Defines User as the authentication model, including open id parameters
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
 
  # Scope for non-deleted users
  named_scope :not_deleted, :conditions => {:deleted => false}


  # ==========================================================================
  # Active Scaffold stuff
  # ==========================================================================
  
  def authorized_for_create?
    !self.deleted &&
    ( Authorization::Engine.instance.permit? :as_create, :user => current_user, :context => :admin_users )
  end

  def authorized_for_read?
    !self.deleted &&
    ( Authorization::Engine.instance.permit? :as_read, :user => current_user, :context => :admin_users ) ||
    ( Authorization::Engine.instance.permit? :as_read, :user => current_user, :context => :admin_deleted_users )
  end

  def authorized_for_update?
    !self.deleted &&
    ( Authorization::Engine.instance.permit? :as_update, :user => current_user, :context => :admin_users ) 
  end

  def authorized_for_delete?
    !self.deleted &&
    ( Authorization::Engine.instance.permit? :as_delete, :user => current_user, :context => :admin_users ) ||
    ( Authorization::Engine.instance.permit? :as_delete, :user => current_user, :context => :admin_deleted_users )
  end

  def groups_authorized_for_update?
    !self.deleted &&
    ( Authorization::Engine.instance.permit? :as_update, :user => current_user, :context => :admin_groups )
  end

  def role_authorized_for_update?
    !self.deleted &&
    ( Authorization::Engine.instance.permit? :manage, :user => current_user, :context => :user_roles )
  end


  # ==========================================================================
  # Instance Methods
  # ==========================================================================

  def avatar
    require 'ostruct'
    OpenStruct.new :path => nil
  end


  # User's label
  def to_label
    "#{self.name} < #{self.email} >"
  end


  # validates when a history entry should be created
  # this method will be used in before update
  def create_history_entry?
    new_user = self
    old_user = User.find self.id
    [:website, :email, :name, :nickname, :gender, :profile, :website, :country, :phone, :emails, :language,:openid_identifier
    ].each do |attribute|
      return true if new_user.send(attribute) != old_user.send(attribute)
    end
    return false
  end

  # Historicable name
  def historicable_name
    first_and_last_name
  end


  #FIXME 
  # DELETE ME or maybe trun me into cached_groups
  def build_cached_groups!
    groups = self.all_groups
    roles = group && group.roles
    roles = self.groups.map(&:roles) unless roles && !roles.empty?
    roles.map { |role| role.name.underscore }
    self.cached_roles = roles.join ", "
    self.save
  end

  # Role symbols from user
  def role_symbols
    [ self.role.label.to_sym ]
  end

  #FIXME 
  # I think this is ok, confirme that this is only used to check email
  def activate!
    self.active = true 
    save
  end
  
  #FIXME
  # If it is only for email, this method should me deleted
  def deactivate!
    self.active = false 
    save
  end

  # Checks if a user is active
  def active?
    self.active
  end

  # Marks as deleted
  def delete!
    self.deleted = true
    save
  end
  
  # Unchecks deleted
  def undelete!
    self.deleted = false
    save
  end  

  # Checks if this user is deleted
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

  # User's first name
  def first_name
    self.name.split(" ").first
  end

  # User's last name
  def last_name
    (names = self.name.split(" ")).length == 1 ? "" : names.last
  end

  # User's first and last name
  def first_and_last_name
    [first_name,last_name].join(" ").chomp " "
  end

  # User's small name
  def small_name
    self.nickname || first_name
  end

  # User's nickname or first and last name
  def nickname_or_first_and_last_name
    self.nickname || first_and_last_name
  end
  
  # Revert user attributes
  def revertTo(xmlUser)
    user_hash = Hash.from_xml(xmlUser)
    self.update_attributes user_hash["user"]
  end  
 
  def list_groups
    r = []
    self.groups.each do |f|
      r << f.name
    end
    r.join ', '
      
  end
   
 
  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self
    # Undeletes users from their ids
    def undelete_by_ids!(ids)
      ids.each do |id|
        return false unless User.find(id).undelete!
      end 
      return true
    end  
    
    #FIXME 
    # maybe overide the delete class method, not sure
    # Deletes users from their ids
    def delete_by_ids!(ids)
      ids.each do |id|
        return false unless User.find(id).delete!
      end 
      return true 
    end
    
    #FIXME 
    # The same research as the instance activate
    # Activates users from their ids
    def activate!(ids)
      ids.each do |id|
        return false unless User.find(id).activate!
      end 
      return true
    end  
    
    #FIXME 
    # The same thing not sure if this should exist
    # Deactivates users from their ids
    def deactivate!(ids)
      ids.each do |id|
        return false unless User.find(id).deactivate!
      end 
      return true
    end

    # Adds users to the specified group
    def add_to_group(group_id, ids)
      group = Group.find group_id
      group.direct_user_ids |= ids.map! &:to_i
      return group.save
    end

    # Removes users to the specified group
    def remove_from_group(group_id, ids)
      group = Group.find group_id
      group.direct_user_ids -= ids.map! &:to_i
      return group.save
    end

    # Method missing override for specific method invocation
    # Method names that matches one of the regular expressions on the list are invoked in a specific way
    # For example, add_to_group_1 [8,9] invokes add_to_group(1, [8,9])
    def method_missing(method_id, *args, &block)
      method_name = method_id.to_s
      [ /(add_to_group)_(\d+)/, /(remove_from_group)_(\d+)/ ].each do |regexp|
        return User.send($1, $2, *args) if method_name =~ regexp
      end
      super
    end
  end

 private
  def map_openid_registration(registration)
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
