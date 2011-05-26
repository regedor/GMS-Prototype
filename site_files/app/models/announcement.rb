class Announcement < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10

  belongs_to :event

  has_attached_file :avatar, :styles => { :announcement => configatron.announcement_size }, :default_url => '/system/:attachment/:style/missing.png'

  validates_presence_of :title, :starts_at, :ends_at, :message
  validates_uniqueness_of :title
 
  named_scope :active, lambda { { :conditions => ['starts_at <= ? AND ends_at >= ?', Time.now.utc, Time.now.utc] } }
  named_scope :since, lambda { |hide_time| { :conditions => (hide_time ? ['updated_at > ? OR starts_at > ?', hide_time.utc, hide_time.utc] : nil) } }
  named_scope :prioritize, :order => "priority desc"
  
  # Displays active announcements
  def self.display(hide_time)
    active.since(hide_time)
  end
  
end
