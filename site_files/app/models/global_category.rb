class GlobalCategory < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================

   has_many :groups
   has_many :posts
   has_many :announcements
   has_many :pages
   has_many :events

  # ==========================================================================
  # Validations
  # ==========================================================================

  before_validation       :generate_slug
  validates_uniqueness_of :slug

  # ==========================================================================
  # Attributes Accessors
  # ==========================================================================

  # ==========================================================================
  # Extra defnitions
  # ==========================================================================

  # ==========================================================================
  # Instance Methods
  # ==========================================================================

   # Generates a unique slug
  def generate_slug
    new_slug = self.name.dup.slugorize
    if self.slug.blank? || !self.slug.starts_with?(new_slug)
      repeated = GlobalCategory.all(:select => 'COUNT(*) as id', :conditions => { :slug => new_slug }).first.id
      self.slug = (repeated > 0) ? "#{new_slug}-#{repeated + 1}" : new_slug
    end 
  end

  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self
    
  end

end