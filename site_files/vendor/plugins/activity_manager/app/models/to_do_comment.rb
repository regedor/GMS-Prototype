class ToDoComment < ActiveRecord::Base
   
  # ==========================================================================
  # Relationships
  # ==========================================================================
  belongs_to :user
  belongs_to :to_do

  
  # ==========================================================================
  # Validations
  # ==========================================================================
  before_save :apply_filter  

  # ==========================================================================
  # Attributes Accessors
  # ==========================================================================

  attr_accessor :users

  # ==========================================================================
  # Extra defnitions
  # ==========================================================================

  has_attached_file :generic
  

  def apply_filter
    self.body_html = TextFormatter.format_as_xhtml(self.body)
  end
 
  class << self
    
    def build_for_preview(params)
      comment = ToDoComment.new(params)      
      comment.apply_filter
      comment
    end
    
  end
 

end
