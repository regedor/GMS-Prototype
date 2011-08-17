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
  
  validates_attachment_size :generic, :less_than => 5.megabytes, :message => 'File size must be less than 5 MegaBytes'

  # ==========================================================================
  # Attributes Accessors
  # ==========================================================================

  attr_accessor :users

  # ==========================================================================
  # Extra defnitions
  # ==========================================================================

  has_attached_file :generic, { 
    :path => ":rails_root/public/system/:attachment/"+self.to_s+"/:id/:style/:filename",
    :url =>  "/system/:attachment/"+self.to_s+"/:id/:style/:filename",
    :styles => lambda {|attachment| (attachment.instance_read(:content_type) =~ /^image\//) ? {:thumb => "50x50"} : {}}
  }  

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
