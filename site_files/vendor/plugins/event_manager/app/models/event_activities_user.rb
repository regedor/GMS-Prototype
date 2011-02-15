class EventActivitiesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :event_activity
  belongs_to :event
  has_one :status

  attr_accessible :event_activity_id
  attr_accessible :event_id
  attr_accessible :user_id
  attr_accessible :confirmed
  attr_accessible :status_id

  before_save :before_save_event

  after_save :after_save_event

  def before_save_event
    self.event_id = self.event_activity.event_id
    self.event.users << User.find(self.user_id) unless self.event.user_ids.include?(self.user_id)
  end

  def after_save_event
    EventsUser.find_by_event_id_and_user_id(self.event_id,self.user_id).update_total_price
  end

  def status
    Status.find(self.status_id)
  end

  def confirm!
    event = self.event
    event.confirm!(self.user_id)
    self.status_id = 2
    self.save!
  end

  def has_status?
    self.status_id != 1
  end

  def undo_confirmation!
    self.status_id = 1
    self.save!
    self.event.undo_confirmation!(user_id) if self.event.undo_confirmation?(user_id)
  end

  def destroy
    eventid = self.event_id
    userid = self.user_id
    super
    events_user = EventsUser.find_by_event_id_and_user_id(eventid,userid)
    if EventActivitiesUser.find_by_event_id_and_user_id(eventid,userid)
      events_user.update_total_price
    else
      events_user.destroy
    end
  end

  def updateStatus(status)
    self.status_id = status
    self.save!
  end

  def self.find_by_event_activity_id_and_text(eventid,stringProcura)
    procura =  'event_activities_users.event_activity_id = ' + eventid.to_s
    stringProcura = stringProcura.gsub(/ +/, ' ').strip.split(' ')
    stringProcura.each do |word|
      procura = procura + ' and users.name like "%' + word + '%"'
    end
    return EventActivitiesUser.all(:conditions => procura, :joins => "INNER JOIN users ON users.id = event_activities_users.user_id")
  end

end
