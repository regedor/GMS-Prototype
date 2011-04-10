class Event < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================
  has_many   :events_users
  has_many   :users, :through => :events_users
  has_many   :event_activities
  belongs_to :post
  belongs_to :announcement

  # ==========================================================================
  # Validations
  # ==========================================================================

  validates_presence_of :description, :name, :starts_at, :ends_at, :price
  
  # ==========================================================================
  # Instance Methods
  # ==========================================================================

  before_save :format_description
  before_save :save_virtual_data
  after_save  :link_to_post

  attr_accessor :starts_at_natural
  attr_accessor :ends_at_natural
  attributes_to_add = Post.new.attributes.keys - ["generic_updated_at","image_file_name","created_at","image_file_size",
                                                  "updated_at","image_content_type","generic_file_name","id","generic_content_type",
                                                  "image_updated_at","generic_file_size"]                                                                                                  
  attributes_to_add.each do |attribute| 
    attr_accessor attribute.to_sym
    define_method((attribute+"_authorized?").to_sym) do
      return false
    end  
  end  
  attr_accessor :tag_list
  has_attached_file :image, :styles => { :image => "250x250" }
  has_attached_file :generic
  
  def image_authorized?;    return false; end 
  def tag_list_authorized?; return false; end 
  def generic_authorized?;  return false; end  

  def save_virtual_data
    unless self.title.blank?
      p = Post.new
      p.title = self.title
      p.body = self.body
      p.tag_list = self.tag_list
      p.published_at = Date.strptime self.published_at, "%d/%m/%Y"
      p.slug = self.slug
   
      if p.valid?
        p.save
        self.post = p
      else
        self.errors[:errors] << p.errors[:errors] if p.errors[:errors]
        return false 
      end   
    end
  end  
  
  def link_to_post
    if self.post
      new_post = self.post
      new_post.event = self
      new_post.save
    end  
  end  

  def initialize(*args)
    super(*args)
    if self.title.blank?
      self.published_at = nil
    end    
  end  

  def format_description
    self.description_html = TextFormatter.format_as_xhtml(self.description)
  end

  def status(user_id)
    self.events_users.find_by_user_id(user_id).status
  end

  def confirm!(user_id)
    user_event = self.events_users.find_by_user_id(user_id)
    return user_event.confirm! if user_event
    false
  end

  def has_status?(user_id)
    user_events = self.events_users.find_by_user_id(user_id)
    return user_events.has_status? if user_events
    false
  end

  def undo_confirmation!(user_id)
    user_events = self.events_users.find_by_user_id(user_id)
    user_events.undo_confirmation!
  end

  def checked_activities(user_id)
    @list = []
    self.event_activities.each do |activity|
      @list << activity if activity.user_ids.include?(user_id)
    end
    return @list
  end

  def unchecked_activities(user_id)
    @list = []
    self.event_activities.each do |activity|
      @list << activity unless activity.user_ids.include?(user_id)
    end
    return @list
  end

  def remove_user_from_event(user_id)
    event_user = self.events_users.find_by_user_id(user_id)
    return event_user.destroy if event_user
    false
  end

  def user_lists
    list = []
    self.events_users.each do |event_user|
      list << { :event_user => event_user, :user => User.find(event_user.user_id) }
    end
    return list
  end

  def self.user_lists(events_users)
    list = []
    events_users.each do |event_user|
      list << { :event_user => event_user, :user => User.find(event_user.user_id) }
    end
    return list
  end

  def self.user_activities(events_users)
    result = Hash.new
    user_ids = []
    events_users.each do |user_event|
      user_ids << user_event.user_id
    end

    user_ids.each do |user_id|
      with_status = []
      default = []
      self.user_event_activities_list(user_id).each do |activity|
        user_activity = activity.event_activities_users.find_by_user_id(user_id)
        if user_activity.has_status?
          with_status << user_activity
        else
          default << user_activity
        end
      end
      result[user_id] = { :with_status => with_status, :default => default }
    end

    return result
  end

  def user_activities
    result = Hash.new
    user_ids = self.user_ids
    user_ids.each do |user_id|
      with_status = []
      default = []
      self.user_event_activities_list(user_id).each do |activity|
        user_activity = activity.event_activities_users.find_by_user_id(user_id)
        if user_activity.has_status?
          with_status << user_activity
        else
          default << user_activity
        end
      end
      result[user_id] = { :with_status => with_status, :default => default }
    end
    return result
  end

  def to_hash
    result = Hash.new
    result[:title] = self.title
    result[:description] = self.description
    #FIXME internacionalization
    result[:starts_at] = self.starts_at
    #FIXME internacionalization
    result[:ends_at] = self.ends_at
    withstatus = []
    default = []
    self.user_lists[:with_status].each do |user_list|
      withstatus << {:name => user_list[:user].name, :email => user_list[:user].email}
    end
    self.user_lists[:default].each do |user_list|
      default << {:name => user_list[:user].name, :email => user_list[:user].email}
    end
    result[:with_status] = withstatus
    result[:without_status] = default
    return result
  end

  def to_hash_with_activities
    result = self.to_hash
    temp = []
    self.event_activities.each do |activity|
      temp << activity.to_hash
    end
    result[:activities] = temp
    return result
  end

  def user_event_activities_list(user_id)
    user_activities = []
    activities = self.event_activities
    activities.each do |activity|
      user_activities << activity if activity.user_ids.include?(user_id)
    end
    return user_activities
  end

  def undo_confirmation?(user_id)
    self.event_activities.each do |activity|
      return false if activity.has_status?(user_id)
    end
    return true
  end

end
