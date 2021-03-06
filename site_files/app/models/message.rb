class Message < ActiveRecord::Base

  # ==========================================================================
  # Relationships
  # ==========================================================================
  belongs_to :user  
  belongs_to :category
  belongs_to :project
  
  has_many   :messages_comments
  
  # ==========================================================================
  # Validations
  # ==========================================================================
  before_save :apply_filter  

  # ==========================================================================
  # Attributes Accessors
  # ==========================================================================

  # ==========================================================================
  # Extra defnitions
  # ==========================================================================

  def apply_filter
    self.body_html = TextFormatter.format_as_xhtml(self.body)
  end
 

end
