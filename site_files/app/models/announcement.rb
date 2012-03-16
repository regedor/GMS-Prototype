class Announcement < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10

  belongs_to :event
  belongs_to :group
  belongs_to :global_category


  has_attached_file :avatar,
    :styles => { :announcement => configatron.announcement_size, :image => "250x250"},
    :default_url => '/system/:attachment/:style/missing.png'


  validates_presence_of :title, :starts_at, :ends_at, :message => I18n::t('flash.cant_be_blank')
  #validates_presence_of :message, :if  => :has_message
  #validates_with DescriptionValidator
  validates_uniqueness_of :title

  before_save do |instance|
    instance.avatar.clear   if instance.avatar_delete == "1"
  end

  attr_accessor :has_message
  attr_writer :avatar_delete
  def avatar_delete ; @avatar_delete ||= "0" ; end

  named_scope :active, :conditions => ['starts_at <= ? AND ends_at >= ?', Time.now.utc, Time.now.utc]
  named_scope :since, lambda { |hide_time| { :conditions => (hide_time ? ['updated_at > ? OR starts_at > ?', hide_time.utc, hide_time.utc] : nil) } }
  named_scope :prioritize, :order => "priority desc"
  named_scope :viewable_only, lambda { |user| {
      :conditions => (user.nil?) ? {"announcements.group_id",[0]} : {"announcements.group_id",user.group_ids+[0]}
    }
  }

  # Displays active announcements
  def self.display(hide_time)
    active.since(hide_time)
  end

  def show? page_slug
    page = Page.find_by_slug page_slug
    return page.show_announcements
  end

end
