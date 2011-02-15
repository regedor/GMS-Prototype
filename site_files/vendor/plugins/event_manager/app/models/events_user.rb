class EventsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_one :status

  attr_accessible :event_id
  attr_accessible :user_id
  attr_accessible :confirmed
  attr_accessible :status_id
  attr_accessible :total_price

  before_create :set_total_price

  def set_total_price
    self.total_price = Event.find(self.event_id).price
  end

  def status
    Status.find(self.status_id)
  end

  def confirm!
    self.status_id = 2
    self.save!
  end

  def has_status?
    self.status_id != 1
  end

  def undo_confirmation!
    self.status_id = 1
    self.save!
  end

  def updateStatus(status)
    self.status_id = status
    self.save!
  end

  def update_total_price
    user_activities = EventActivitiesUser.find_all_by_event_id_and_user_id(self.event_id,self.user_id)
    count = 0.0
    if !user_activities.empty?
      user_activities.each do |activity|
        count = count + activity.event_activity.price
      end
      if (count > 0)
        self.total_price = count
      else
        self.total_price = Event.find(self.event_id).price
      end
    else self.total_price = Event.find(self.event_id).price
    end
    self.save!
  end

  def self.find_by_event_id_and_text(eventid,stringProcura)
    procura = ' events_users.event_id = ' + eventid.to_s
    stringProcura = stringProcura.gsub(/ +/, ' ').strip.split(' ')
    stringProcura.each do |word|
      procura = procura + ' and users.name like "%' + word + '%"'
    end
    return EventsUser.all(:conditions => procura, :joins => "INNER JOIN users ON users.id = events_users.user_id")
  end

end
