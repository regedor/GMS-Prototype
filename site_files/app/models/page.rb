class Page < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================

  belongs_to :group
  belongs_to :global_category
  has_many   :approved_comments, :as => 'commentable', :dependent => :destroy, :class_name => 'Comment'


  # ==========================================================================
  # Validations
  # ==========================================================================

  validates_presence_of   :title, :body
  validates_uniqueness_of :slug
  before_validation       :generate_slug
  belongs_to              :group


  # ==========================================================================
  # Extra definitions
  # ==========================================================================

  # Makes this model historicable
  include HistoryEntry::Historicable

  before_save           :apply_filter
  after_save            :reload_routes
  named_scope :navigation_pages, :conditions => {:show_in_navigation => true}, :order => "priority desc"
  named_scope :viewable_only, lambda { |user| {
      :conditions => (user.nil?) ? {"pages.group_id",[0]} : {"pages.group_id",user.group_ids+[0]}
    }
  }

  # ==========================================================================
  # Instance Methods
  # ==========================================================================

  def apply_filter
    self.body_html = TextFormatter.format_as_xhtml(self.body)
  end

  def active?
    true
  end

  # Generates a unique slug
  def generate_slug
    new_slug = self.title.dup.to_url
    if self.slug.blank? || !self.slug.starts_with?(new_slug)
      repeated = Page.all(:select => 'COUNT(*) as id', :conditions => { :slug => new_slug }).first.id
      self.slug = (repeated > 0) ? "#{new_slug}-#{repeated + 1}" : new_slug
    end
  end
  
  def reload_routes
    ActionController::Routing::Routes.reload!
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

    # Finds a page by its slug
    def find_by_slug slug
      (Page.all :conditions => { :slug => slug }).first
    end
  end

end
