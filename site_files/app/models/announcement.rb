class Announcement < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10

  has_attached_file :avatar, :styles => { :announcement => "730x250#" }, :default_url => '/system/:attachment/:style/missing.png'

  validates_presence_of :title
  validates_uniqueness_of :title
 
  named_scope :active, lambda { { :conditions => ['starts_at <= ? AND ends_at >= ?', Time.now.utc, Time.now.utc] } }
  named_scope :since, lambda { |hide_time| { :conditions => (hide_time ? ['updated_at > ? OR starts_at > ?', hide_time.utc, hide_time.utc] : nil) } }
  named_scope :prioritize, :order => "priority desc"
  
  # Displays active announcements
  def self.display(hide_time)
    active.since(hide_time)
  end
  
end
