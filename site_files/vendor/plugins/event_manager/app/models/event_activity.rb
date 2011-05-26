class EventActivity < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================
  belongs_to :event
  has_many :event_activities_users
  has_many :users
  has_many :users, :through => :event_activities_users

  # ==========================================================================
  # Validations
  # ==========================================================================
  validates_presence_of :event
  validates_presence_of :description

  # ==========================================================================
  # Instance Methods
  # ==========================================================================

  #before_save :format_description

  def html_representation
    "<span class='title'>"+self.title+"</span><span class='price'>"+self.price.to_s+"</span>"
  end  

  def format_description
    self.description_html = TextFormatter.format_as_xhtml(self.description)
  end

  def status(user_id)
    self.event_activities_users.find_by_user_id(user_id).status
  end

  def confirm!(user_id)
    user_event = self.event_activities_users.find_by_user_id(user_id)
    return user_event.confirm! if user_event
    false
  end

  def has_status?(user_id)
    user_events = self.event_activities_users.find_by_user_id(user_id)
    return user_events.has_status? if user_events
    false
  end

  def undo_confirmation!(user_id)
    user_events = self.event_activities_users.find_by_user_id(user_id)
    user_events.undo_confirmation!
  end

  def remove_user_from_activity(user_id)
    event_user = self.event_activities_users.find_by_user_id(user_id)
    return event_user.destroy if event_user
    false
  end

  def user_lists
    with_status = []
    default = []
    self.event_activities_users.each do |event_user|
      if event_user.has_status?
        with_status << { :activity_user => event_user, :user => User.find(event_user.user_id) }
      else
        default << { :activity_user => event_user, :user => User.find(event_user.user_id) }
      end
    end
    return {:with_status => with_status, :default => default}
  end

  def self.user_lists(events_users)
    with_status = []
    default = []
    events_users.each do |event_user|
      if event_user.has_status?
        with_status << { :activity_user => event_user, :user => User.find(event_user.user_id) }
      else
        default << { :activity_user => event_user, :user => User.find(event_user.user_id) }
      end
    end
    return {:with_status => with_status, :default => default}
  end

  def to_hash
    result = Hash.new
    result[:title] = self.title
    result[:description] = self.description
    #FIXME internacionalization
    result[:starts_at] = self.starts_at
    #FIXME internacionalization
    result[:ends_at] = self.ends_at
    confirmed = []
    notConfirmed = []
    self.user_lists[:confirmed].each do |user_list|
      confirmed << {:name => user_list[:user].name, :email => user_list[:user].email}
    end
    self.user_lists[:notConfirmed].each do |user_list|
      notConfirmed << {:name => user_list[:user].name, :email => user_list[:user].email}
    end
    result[:confirmed] = confirmed
    result[:notConfirmed] = notConfirmed
    return result
  end


end
