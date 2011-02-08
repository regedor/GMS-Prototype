class Page < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================
  
  belongs_to :group
  has_many   :approved_comments, :as => 'commentable', :dependent => :destroy, :class_name => 'Comment'


  # ==========================================================================
  # Validations
  # ==========================================================================

  validates_presence_of   :title, :slug, :body
  validates_uniqueness_of :slug
  before_validation       :generate_slug


  # ==========================================================================
  # Extra definitions
  # ==========================================================================

  # Makes this model historicable
  include HistoryEntry::Historicable

  before_save           :apply_filter
  named_scope :navigation_pages, :conditions => {:show_in_navigation => true}, :order => "priority desc"

  # ==========================================================================
  # Instance Methods
  # ==========================================================================

  def apply_filter
    self.body_html = EnkiFormatter.format_as_xhtml(self.body)
  end

  def active?
    true
  end

  def generate_slug
    self.slug = self.title.dup if self.slug.blank?
    self.slug.slugorize!
  end


  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self
    def build_for_preview(params)
      page = Page.new(params)
      page.apply_filter
      page
    end

    def find_by_slug slug
      (Page.all :conditions => { :slug => slug }).first
    end
  end

end

