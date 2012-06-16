class User < ActiveRecord::Base

  # ==========================================================================
  # Relationships
  # ==========================================================================

  has_many   :groups_users  
  has_many   :groups, :through => :groups_users
  has_many   :choosable_groups, :through => :groups_users, :source => :group, :conditions => { :user_choosable => true }
  has_many   :positions
  belongs_to :role


  # ==========================================================================
  # Validations
  # ==========================================================================
  
  validates_presence_of   :language
  validates_presence_of   :email

  validates_format_of     :phone,
    :with => /(^[\(\)0-9\- \+\.]{9,20} *[extension\.]{0,9} *[0-9]{0,5}$)|(^$)/i 

  before_save             :validate_role

  # Validates if every optional group pick for the user has one and only one group chosen
  def validate_group_picks(picks=nil)
    validation_errors = []
    picks = UserOptionalGroupPick.for_user(self) if picks.nil?
    picks.each do |pick|
      intersection = pick.groups & self.groups
      if intersection.length != 1
        if intersection.length == 0
          validation_errors << I18n::t('users.errors.user_optional_group_picks.zero',
                                       :name => pick.name)
        else
          validation_errors << I18n::t('users.errors.user_optional_group_picks.multiple',
                                       :name => pick.name,
                                       :groups => intersection.map(&:name).join(', '))
        end
      end
    end
    return validation_errors
  end

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
  attr_accessible  :emails #does the user want to receive emails 
  attr_accessible  :language            
  attr_accessible  :openid_identifier   
  attr_accessible  :groups
  attr_accessible  :row_mark #scaffold hack
  attr_accessible  :address
  attr_accessible  :id_number

  boolean_attr_accessor 'active', :trueifier => 'activate', :falsifier => 'deactivate'

  # ==========================================================================
  # Extra definitions
  # ==========================================================================

  named_scope :relevant, lambda { |query_string| { :conditions => "name LIKE '%%%#{query_string}%%'", :limit => 10} } 

  #after_save :update_behaviour_delayed_jobs

  has_attached_file :avatar, :styles => { :medium => "100x100#", :small => "50x50#" }

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
  default_scope :conditions => {:deleted => false}


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

  # Method for Declarative Authorization, to know which roles user have. 
  # It needs user roles inside an array (this case, only have one role)
  def role_symbols
    [ self.role.label.to_sym ]
  end

  # Historicable overrides
  # validates when a history entry should be created
  # this method will be used in before update
  def create_history_entry?
    new_user = self
    old_user = self.class.find self.id
    [:website, :email, :name, :nickname, :gender, :profile, :website, :country, :phone, :emails, :language,:openid_identifier
    ].each do |attribute|
      return true if new_user.send(attribute) != old_user.send(attribute)
    end
    return false
  end

  # Overrides default historicable name
  def historicable_name
    first_and_last_name
  end

  # User's label
  def to_label
    "#{self.first_and_last_name} < #{self.email} >".strip
  end

  #FIXME 
  # DELETE ME or maybe turn me into cached_groups
  def build_cached_groups!
    groups = self.all_groups
    roles = group && group.roles
    roles = self.groups.map(&:roles) unless roles && !roles.empty?
    roles.map { |role| role.name.underscore }
    self.cached_roles = roles.join ", "
    self.save
  end

  # Marks as deleted
  def destroy
    self.deleted = true
    save
  end
  
  def send_invitation!(mail)
    Notifier.deliver_invitation(self,mail)
  end
  #handle_asynchronously :send_invitation!

  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end
  #handle_asynchronously :deliver_activation_instructions!

  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end
  #handle_asynchronously :deliver_activation_confirmation!

  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.deliver_password_reset_instructions(self)  
  end  
  #handle_asynchronously :deliver_password_reset_instructions!

  # User's first name
  def first_name
    self.name.nil? ? "" : self.name.split(" ").first
  end

  # User's last name
  def last_name
    return "" if self.name.nil?
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
  
  def name(just_name=false)
    (just_name) ? super : (super.blank? || !super) ? self.email : super
  end

  def list_groups
    r = []
    self.groups.each do |f|
      r << f.name
    end
    r.join ', '
      
  end
  
  def delete!
    self.deleted=true
    save
  end
  
 
  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self

    #FIXME should be done in single bd query
    # Deletes users from their ids, method for deleted users.
    def destroy_by_ids!(ids)
      ids.each do |id|
        return false unless DeletedUser.find(id).delete
      end 
      return true 
    end
    
    def delete_by_ids!(ids)
      ids.each do |id|
        return false unless User.find(id).delete!
      end 
      return true
    end
    
    #FIXME should be done in single bd query
    # Activates users from their ids
    def activate!(ids)
      ids.each do |id|
        return false unless User.find(id).activate!
      end 
      return true
    end  
    
    #FIXME should be done in single bd query
    # Deactivates users from their ids
    def deactivate!(ids)
      ids.each do |id|
        return false unless User.find(id).deactivate!
      end 
      return true
    end
    
    def undelete_by_ids(ids)
      ids.each do |id|
        return false unless DeletedUser.find(id).undelete!
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
  
  def validate_role
    self.role_id= Role.id_for(:user) if self.role == nil
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
      self.name     = registration['http://axschema.org/namePerson/first'].to_s + ' ' + 
                      registration['http://axschema.org/namePerson/last'].to_s
      self.language = registration['http://axschema.org/pref/language'].to_s if UserSession::LANGUAGES.map(&:last).include? registration['language']
      self.country  = registration['http://axschema.org/contact/country/home'].to_s
    end
  end

  def update_behaviour_delayed_jobs
    self.groups.map &:update_behaviour_delayed_jobs
  end

end
